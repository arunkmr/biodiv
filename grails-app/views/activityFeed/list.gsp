<%@page import="species.utils.Utils"%>
<html>
<head>
<link rel="canonical" href="${Utils.getIBPServerDomain() + createLink(controller:'activityFeed', action:'list')}" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="layout" content="main" />
<g:set var="entityName"
	value="${message(code: 'feeds.label', default: 'Activity')}" />
<title><g:message code="default.list.label" args="[entityName]" />
</title>
<%--<script src="http://maps.google.com/maps/api/js?sensor=true"></script>--%>
<r:require modules="activityfeed,comment"/>
</head>
<body>
	
			<div class="span12">
				<div class="page-header clearfix">
						<h1>
							<g:message code="default.observation.heading" args="[entityName]" />
						</h1>
				</div>

				<g:if test="${flash.message}">
					<div class="message alert alert-info">
						${flash.message}
					</div>
				</g:if>
				<uGroup:rightSidebar model="['userGroupInstance':userGroupInstance]"/>
				<div class="userGroup-section center_panel">
					<feed:showFeedWithFilter model="[feedType:feedType, feedCategory:'All','feedOrder':'latestFirst']" />
				</div>
			</div>
		
	<r:script>
	</r:script>
</body>
</html>
