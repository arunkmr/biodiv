package species.participation.curation

import species.auth.SUser;
import species.Language;
import species.participation.Observation
import species.participation.Recommendation

class CurationService {

	static transactional = false

	def springSecurityService
	def grailsApplication
	
	def add(Recommendation recoForSciName,  Recommendation recoForCommonName, refObject, author){
		/*
		UnCuratedScientificNames unSciName;
		UnCuratedCommonNames unCn;

		if(isAuthenticRecos(recoForSciName, recoForCommonName)){
			log.info "Correct SN-CN mapping.. no need to go in dirty table "
			return
		}

		//if common name is given always insert for curation even if it has taxonconcept
		if(recoForCommonName){
			unCn = getUnCuratedCommonName(recoForCommonName);
		}

		//if SN is given
		if(recoForSciName){
			//checking for authenticated recommendation
			boolean isAuthenticatedSciName = (recoForSciName.taxonConcept != null)
			//if new sci name is given
			if(!isAuthenticatedSciName){
				unSciName = getUnCuratedScientificName(recoForSciName);
			}

			//if a common name is given then adding common name to this sn
			//in this case if SN is authentic then also stroing in uncuratedSN so that
			//can hold common names mapping
			if(unCn){
				unSciName = unSciName?:getUnCuratedScientificName(recoForSciName);
				def flushImmediately  = grailsApplication.config.speciesPortal.flushImmediately
				if(!unSciName.addToCommonNames(unCn).save(flush:flushImmediately)){
					log.error "Error during add of cn in sn"
				}
			}
		}

		addUnCuratedRecommendationVote(unSciName, unCn, refObject, author);
		*/
	}

	private boolean isAuthenticRecos(Recommendation recoForSciName, Recommendation recoForCommonName){
		return (recoForSciName && recoForCommonName && recoForSciName.taxonConcept != null 
			&& recoForSciName.taxonConcept == recoForCommonName.taxonConcept)
	}


	private addUnCuratedRecommendationVote(sn, cn, refObject, author){
		def flushImmediately  = grailsApplication.config.speciesPortal.flushImmediately
		
		//XXX for migrating check list
		//author = SUser.read(1)
		//uncomment this
		author = author?:springSecurityService.currentUser;
		
		UnCuratedVotes uv = UnCuratedVotes.findWhere(author:author, sciName:sn, commonName:cn, refType: refObject.class.getCanonicalName(), refId:refObject.id)
		if(!uv){
			uv = new UnCuratedVotes(author:author, sciName:sn, commonName:cn, refType:refObject.class.getCanonicalName(), refId:refObject.id);
			if(!uv.save(flush:flushImmediately)){
				log.error "Error during UnCuratedVotes save === "
				uv.errors.allErrors.each { log.error it }
			}

			//incrementing referecne counter
			if(sn){
				sn.referanceCounter++
				if(!sn.save(flush:flushImmediately)){
					log.error "Error during UnCuratedVotes(sn, cn) save"
				}
			}

			if(cn){
				cn.referanceCounter++
				if(!cn.save(flush:flushImmediately)){
					log.error "Error during UnCuratedVotes(sn, cn) save"
				}
			}
		}

	}

	private deleteUnCuratedVotes(id){
		UnCuratedVotes unRecoVote = UnCuratedVotes.get(id)
		if(!unRecoVote){
			log.error "Wrong id = $id given for uncurated vote deletion"
			return
		}
		updateOrDeleteObj(unRecoVote.sciName);
		updateOrDeleteObj(unRecoVote.commonName);

		if(unRecoVote.delete(flush:true)){
			log.error "Error while delete object $obj"
		}
	}

	private updateOrDeleteObj(obj){
		if(!obj){
			return
		}

		if((obj.referanceCounter--) == 0){
			if(!obj.delete(flush:true)){
				log.error "Error while delete object $obj"
			}
		}else{
			if(!obj.save(flush:true)){
				log.error "Error while saving object $obj"
			}
		}
	}

	private UnCuratedCommonNames getUnCuratedCommonName(Recommendation reco){
		def c = UnCuratedCommonNames.createCriteria()
		UnCuratedCommonNames unCn = c.get{
			ilike('name', reco.name);
			(reco.languageId) ? eq('language', Language.read(reco.languageId)) : isNull('language');
		}
		if(!unCn){
			unCn = new UnCuratedCommonNames(name:reco.name, language:Language.read(reco.languageId), reco:reco);
			def flushImmediately  = grailsApplication.config.speciesPortal.flushImmediately
			if(!unCn.save(flush:flushImmediately)){
				log.error "Error during UnCuratedCommonNames save"
				unCn = null
			}
		}
		return unCn
	}

	private UnCuratedScientificNames getUnCuratedScientificName(Recommendation recoForSciName){
		//UnCuratedScientificNames unSciName = UnCuratedScientificNames.findByNameIlike(scientificName);
		UnCuratedScientificNames unSciName = UnCuratedScientificNames.findByReco(recoForSciName);
		boolean isAuthenticated = (recoForSciName.taxonConcept != null);
		if(!unSciName){
			unSciName = new UnCuratedScientificNames(name:recoForSciName.name, reco:recoForSciName,isAuthenticated:isAuthenticated)
			def flushImmediately  = grailsApplication.config.speciesPortal.flushImmediately
			if(!unSciName.save(flush:flushImmediately)){
				log.error "Error during UnCuratedScientificNames save"
				unSciName = null
			}
		}
		return unSciName
	}

}
