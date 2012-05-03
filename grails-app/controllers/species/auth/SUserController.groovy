package species.auth

import grails.converters.JSON
import grails.plugins.springsecurity.Secured;
import grails.plugins.springsecurity.ui.AbstractS2UiController;
import grails.plugins.springsecurity.ui.SpringSecurityUiService
import grails.plugins.springsecurity.ui.UserController;
import grails.util.GrailsNameUtils

import java.util.List
import java.util.Map

import org.codehaus.groovy.grails.plugins.springsecurity.NullSaltSource
import org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils
import org.springframework.dao.DataIntegrityViolationException


class SUserController extends UserController {

	def springSecurityService

	static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

	def index = {
		redirect(action: "list", params: params)
	}

	def list = {
		params.max = Math.min(params.max ? params.int('max') : 10, 100)
		def model = [results: SUser.list(params), totalCount: SUser.count()]
		render view: 'search', model: model
	}

	@Secured(['ROLE_ADMIN'])
	def create = {
		def user = lookupUserClass().newInstance(params)
		[user: user, authorityList: sortedRoles()]
	}

	@Secured(['ROLE_ADMIN'])
	def save = {
		def user = lookupUserClass().newInstance(params)
		if (params.password) {
			String salt = saltSource instanceof NullSaltSource ? null : params.username
			user.password = SpringSecurityUiService.encodePassword(params.password, salt)
		}
		if (!user.save(flush: true)) {
			render view: 'create', model: [user: user, authorityList: sortedRoles()]
			return
		}

		addRoles(user)
		flash.message = "${message(code: 'default.created.message', args: [message(code: 'user.label', default: 'User'), user.id])}"
		redirect action: edit, id: user.id
	}

	def show = {
		if(!params.id) {
			params.id = springSecurityService.currentUser?.id;
		}

		def SUserInstance = SUser.get(params.long("id"))
		if (!SUserInstance) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'SUser.label', default: 'SUser'), params.id])}"
			redirect(action: "list")
		}
		else {
			[SUserInstance: SUserInstance]
		}
	}

	@Secured(['ROLE_USER'])
	def edit = {
		log.debug params;
		String usernameFieldName = SpringSecurityUtils.securityConfig.userLookup.usernamePropertyName

		if(params.long('id') == springSecurityService.currentUser?.id) {
			def user = params.username ? lookupUserClass().findWhere((usernameFieldName): params.username) : null
			if (!user) user = findById()
			if (!user) return

				return buildUserModel(user)
		}
		flash.message = "${message(code: 'edit.denied.message')}";
		redirect (action:'show', id:params.id)
	}

	@Secured(['ROLE_USER'])
	def update = {
		log.debug params;
		String passwordFieldName = SpringSecurityUtils.securityConfig.userLookup.passwordPropertyName

		def user = findById()

		if (!user) return

			if (!versionCheck('user.label', 'User', user, [user: user])) {
				return
			}

		if(params.long('id') == springSecurityService.currentUser?.id) {
			//Cannot change email id with which user was registered
			params.email = user.email;
			
			def oldPassword = user."$passwordFieldName"
			user.properties = getTrimmedParams(params)
			if (params.password && !params.password.equals(oldPassword)) {
				String salt = saltSource instanceof NullSaltSource ? null : params.username
				user."$passwordFieldName" = springSecurityUiService.encodePassword(params.password, salt)
			}
			
			user.sendNotification = (params.sendNotification?.equals('on'))?true:false;
				
			if (!user.save(flush: true)) {
				render view: 'edit', model: buildUserModel(user)
				return
			}

			String usernameFieldName = SpringSecurityUtils.securityConfig.userLookup.usernamePropertyName

			//lookupUserRoleClass().removeAll user
			//addRoles user
			userCache.removeUserFromCache user[usernameFieldName]
			flash.message = "${message(code: 'default.updated.message', args: [message(code: 'user.label', default: 'User'), user.id])}"
			redirect action: show, id: user.id
		} else {
			flash.message = "${message(code: 'update.denied.message')}";
			redirect (action:'show', id:params.id)
		}
	}

	@Secured(['ROLE_ADMIN'])
	def delete = {
		def user = findById()
		if (!user) return

			String usernameFieldName = SpringSecurityUtils.securityConfig.userLookup.usernamePropertyName
		try {
			lookupUserRoleClass().removeAll user
			user.delete flush: true
			userCache.removeUserFromCache user[usernameFieldName]
			flash.message = "${message(code: 'default.deleted.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
			redirect action: search
		}
		catch (DataIntegrityViolationException e) {
			flash.error = "${message(code: 'default.not.deleted.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
			redirect action: edit, id: params.id
		}
	}

	def search = {
		//[enabled: 0, accountExpired: 0, accountLocked: 0, passwordExpired: 0]
		redirect action:userSearch
	}

	/**
	 * 
	 */
	def userSearch = {
		log.debug params
		
		boolean useOffset = params.containsKey('offset')
		setIfMissing 'max', 12, 100
		setIfMissing 'offset', 0

		def hql = new StringBuilder('FROM ').append(lookupUserClassName()).append(' u WHERE 1=1 ')
		def cond = new StringBuilder("");
		def queryParams = [:]

		def userLookup = SpringSecurityUtils.securityConfig.userLookup
		String usernameFieldName = 'name'

		params.sort = params.sort ?: "activity";
		for (name in [username: usernameFieldName]) {
			if (params[name.key]) {
				cond.append " AND LOWER(u.${name.value}) LIKE :${name.key}"
				queryParams[name.key] = '%' + params[name.key].toLowerCase() + '%'
			}
		}

		String enabledPropertyName = userLookup.enabledPropertyName
		String accountExpiredPropertyName = userLookup.accountExpiredPropertyName
		String accountLockedPropertyName = userLookup.accountLockedPropertyName
		String passwordExpiredPropertyName = userLookup.passwordExpiredPropertyName

		for (name in [enabled: enabledPropertyName,
			accountExpired: accountExpiredPropertyName,
			accountLocked: accountLockedPropertyName,
			passwordExpired: passwordExpiredPropertyName]) {
			Integer value = params.int(name.key)
			if (value) {
				cond.append " AND u.${name.value}=:${name.key}"
				queryParams[name.key] = value == 1
			}
		}

		hql.append cond;
		int totalCount = lookupUserClass().executeQuery("SELECT COUNT(DISTINCT u) $hql", queryParams)[0]

		Integer max = params.int('max')
		Integer offset = params.int('offset')

		String orderBy = ''
		if (params.sort == 'lastLoginDate') {
			orderBy = " ORDER BY u.$params.sort ${params.order ?: 'DESC'},  u.$usernameFieldName ASC"
		} else {
			orderBy = " ORDER BY u.$params.sort ${params.order ?: 'ASC'}"
		}

		
		def results = []; 
		if(params.sort == 'activity') {
			String query = "select u.id, u.$usernameFieldName from Observation obv right outer join obv.author u WHERE 1=1 $cond group by u.id, u.$usernameFieldName order by count(obv.id)  desc, u.$usernameFieldName asc";
			def uids =  lookupUserClass().executeQuery(query, queryParams, [max: max, offset: offset])
			uids.each {
				results.add(SUser.read(it[0]));
			}
		} else {
			String query = "SELECT DISTINCT u $hql $orderBy";
			results = lookupUserClass().executeQuery(query, queryParams, [max: max, offset: offset])
		}
		
		
		def model = [results: results, totalCount: totalCount, searched: true]

		// add query params to model for paging
		for (name in [
			'username',
			'enabled',
			'accountExpired',
			'accountLocked',
			'passwordExpired',
			'sort',
			'order'
		]) {
			model[name] = params[name]
		}

		render view: 'search', model: model
	}

	/**
	 * Ajax call used by autocomplete textfield.
	 */
	def ajaxUserSearch = {
		log.debug params
		
		def jsonData = []

		if (params.term?.length() > 2) {
			String username = params.term
			String usernameFieldName = 'name';//SpringSecurityUtils.securityConfig.userLookup.usernamePropertyName

			setIfMissing 'max', 10, 100

			def results = lookupUserClass().executeQuery(
					"SELECT DISTINCT u.$usernameFieldName " +
					"FROM ${lookupUserClassName()} u " +
					"WHERE LOWER(u.$usernameFieldName) LIKE :name " +
					"ORDER BY u.$usernameFieldName",
					[name: "${username.toLowerCase()}%"],
					[max: params.max])

			for (result in results) {
				jsonData << [value: result]
			}
		}

		render text: jsonData as JSON, contentType: 'text/plain'
	}

        def login = {
            render  template:"/common/suser/userLoginBoxTemplate" 
        }

	protected void addRoles(user) {
		String upperAuthorityFieldName = GrailsNameUtils.getClassName(
				SpringSecurityUtils.securityConfig.authority.nameField, null)

		for (String key in params.keySet()) {
			if (key.contains('ROLE') && 'on' == params.get(key)) {
				lookupUserRoleClass().create user, lookupRoleClass()."findBy$upperAuthorityFieldName"(key), true
			}
		}
	}

	protected Map buildUserModel(user) {

		String authorityFieldName = SpringSecurityUtils.securityConfig.authority.nameField
		String authoritiesPropertyName = SpringSecurityUtils.securityConfig.userLookup.authoritiesPropertyName

		List roles = sortedRoles()
		Set userRoleNames = user[authoritiesPropertyName].collect { it[authorityFieldName] }
		def granted = [:]
		def notGranted = [:]
		for (role in roles) {
			String authority = role[authorityFieldName]
			if (userRoleNames.contains(authority)) {
				granted[(role)] = userRoleNames.contains(authority)
			}
			else {
				notGranted[(role)] = userRoleNames.contains(authority)
			}
		}

		return [user: user, roleMap: granted + notGranted]
	}

	protected findById() {
		def user = lookupUserClass().get(params.long('id'))
		if (!user) {
			flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])}"
			redirect action: search
		}

		user
	}

	protected List sortedRoles() {
		lookupRoleClass().list().sort { it.authority }
	}
	
	private Map getTrimmedParams(Map m){
		def res = [:]
		m.each {key, value -> res[key] = value.toString().trim()}
		return res
	}
}
