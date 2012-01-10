package speciespage

import java.util.List;

import java.util.List

import org.apache.commons.logging.LogFactory

import species.Classification
import species.Country
import species.DataLoader
import species.Field
import species.Language
import species.Species
import species.TaxonomyDefinition;
import species.License.LicenseType
import species.formatReader.SpreadsheetReader
import species.search.SearchIndexManager
import species.sourcehandler.KeyStoneDataConverter
import species.sourcehandler.MappedSpreadsheetConverter
import species.sourcehandler.NewSpreadsheetConverter
import species.sourcehandler.SpreadsheetConverter
import species.sourcehandler.XMLConverter

class SpeciesService {

	private static final log = LogFactory.getLog(this);

	static transactional = false

	def grailsApplication;
	def groupHandlerService;
	def namesLoaderService;

	static int BATCH_SIZE = 10;

	/**
	 * 
	 * @return
	 */
	def loadData() {
		def dataLoader = new DataLoader();
		int noOfInsertions = 0;

		grailsApplication.config.speciesPortal.images.uploadDir = grailsApplication.config.speciesPortal.data.rootDir+"/speciespages/speciespageszip/mango/mango";
		noOfInsertions += uploadSpreadsheet(grailsApplication.config.speciesPortal.data.rootDir+"/speciespages/speciespageszip/mango/mango/MangoMangifera_indica_prabha_v4 (copy).xlsx", 0, 0, 1, 4);

		grailsApplication.config.speciesPortal.images.uploadDir = grailsApplication.config.speciesPortal.data.rootDir+"/speciespages/speciespageszip/grey_falcolin";
		noOfInsertions += uploadSpreadsheet(grailsApplication.config.speciesPortal.data.rootDir+"/speciespages/speciespageszip/grey_falcolin/GreyFrancolin_v4.xlsx", 0, 0, 1, 4);

		grailsApplication.config.speciesPortal.images.uploadDir = grailsApplication.config.speciesPortal.data.rootDir+"/speciespages/Rufous Woodpecker/images";
		noOfInsertions += uploadNewSpreadsheet(grailsApplication.config.speciesPortal.data.rootDir+"/speciespages/Rufous Woodpecker/RufousWoodepecker_v4_1.xlsm");

		grailsApplication.config.speciesPortal.images.uploadDir = grailsApplication.config.speciesPortal.data.rootDir+"/speciespages/Eurasian Curlew/png ec";
		noOfInsertions += uploadNewSpreadsheet(grailsApplication.config.speciesPortal.data.rootDir+"/speciespages/Eurasian Curlew/EurasianCurlew_v4_2.xlsm");

		grailsApplication.config.speciesPortal.images.uploadDir = grailsApplication.config.speciesPortal.data.rootDir+"/speciespages/images";
		noOfInsertions += uploadMappedSpreadsheet(grailsApplication.config.speciesPortal.data.rootDir+"/speciespages/Dung_beetle_Species_pages_IBP_v13.xlsx", grailsApplication.config.speciesPortal.data.rootDir+"/mappings/dungbeetles_mapping.xlsx", 0, 0, 0, 0);

		grailsApplication.config.speciesPortal.images.uploadDir = grailsApplication.config.speciesPortal.data.rootDir+"/speciespages/images";
		noOfInsertions += uploadMappedSpreadsheet(grailsApplication.config.speciesPortal.data.rootDir+"/speciespages/Trees_descriptives_prabha_final_6.xlsx", grailsApplication.config.speciesPortal.data.rootDir+"/mappings/ifp_tree_mapping_v2.xlsx", 0, 0, 0, 2);

		//grailsApplication.config.speciesPortal.images.uploadDir = grailsApplication.config.speciesPortal.data.rootDir+"/speciespages/images";
		noOfInsertions += uploadMappedSpreadsheet(grailsApplication.config.speciesPortal.data.rootDir+"/speciespages/Bats/WG_bats_account_01Nov11_sanjayMolur.xls", grailsApplication.config.speciesPortal.data.rootDir+"/mappings/WG_bats_account_01Nov11_sanjayMolurspecies_mapping_v2.xlsx", 0, 0, 0, 0);

		grailsApplication.config.speciesPortal.images.uploadDir = grailsApplication.config.speciesPortal.data.rootDir+"/speciespages/keystone";
		String mappingFile = grailsApplication.config.speciesPortal.data.rootDir+"/speciespages/keystone/keystone_mapping_v1.xlsx";
		noOfInsertions += uploadKeyStoneData("jdbc:mysql://localhost:3306/ezpz", "sravanthi", "sra123", mappingFile, 0, 0);

		grailsApplication.config.speciesPortal.images.uploadDir = grailsApplication.config.speciesPortal.data.rootDir+"/speciespages/speciespages";
		noOfInsertions += uploadMappedSpreadsheet(grailsApplication.config.speciesPortal.data.rootDir+"/speciespages/speciespages/species accounts188_v2.xlsx", grailsApplication.config.speciesPortal.data.rootDir+"/mappings/speciesaccount188_mapping_v1.xlsx", 0, 0, 0, 0);
		
		return noOfInsertions;
	}


	/**
	 * 
	 * @param file
	 * @param mappingFile
	 * @param mappingSheetNo
	 * @param mappingHeaderRowNo
	 * @param contentSheetNo
	 * @param contentHeaderRowNo
	 * @return
	 */
	int uploadMappedSpreadsheet (String file, String mappingFile, int mappingSheetNo, int mappingHeaderRowNo, int contentSheetNo, int contentHeaderRowNo) {
		log.debug "Uploading mapped spreadsheet : "+file;
		List<Species> species = MappedSpreadsheetConverter.getInstance().convertSpecies(file, mappingFile, mappingSheetNo, mappingHeaderRowNo, contentSheetNo, contentHeaderRowNo);
		return saveSpecies(species);
	}

	/**
	 * 
	 * @param file
	 * @param contentSheetNo
	 * @param contentHeaderRowNo
	 * @param imageMetadataSheetNo
	 * @param imageMetaDataHeaderRowNo
	 * @return
	 */
	int uploadSpreadsheet (String file, int contentSheetNo, int contentHeaderRowNo, int imageMetadataSheetNo, int imageMetaDataHeaderRowNo) {
		log.debug "Uploading spreadsheet : "+file;
		List<Species> species = SpreadsheetConverter.getInstance().convertSpecies(file, contentSheetNo, contentHeaderRowNo, imageMetadataSheetNo, imageMetaDataHeaderRowNo);
		return saveSpecies(species);
	}

	/**
	 * 
	 * @param file
	 * @return
	 */
	int uploadNewSpreadsheet (String file) {
		log.debug "Uploading new spreadsheet : "+file;
		List<Species> species = NewSpreadsheetConverter.getInstance().convertSpecies(file);
		return saveSpecies(species);
	}

	/**
	 * 
	 * @param connectionUrl
	 * @param userName
	 * @param password
	 * @param mappingFile
	 * @param mappingSheetNo
	 * @param mappingHeaderRowNo
	 * @return
	 */
	int uploadKeyStoneData (String connectionUrl, String userName, String password, String mappingFile, int mappingSheetNo, int mappingHeaderRowNo) {
		log.debug "Uploading keystone data";
		List<Species> species = KeyStoneDataConverter.getInstance().convertSpecies(connectionUrl, userName, password, mappingFile, mappingSheetNo, mappingHeaderRowNo);
		return saveSpecies(species);
	}

	/**
	 * 
	 * @param species
	 * @return
	 */
	int saveSpecies(List species) {
		log.debug "Saving species : "+species.size()
		int noOfInsertions = 0;
		def startTime = System.currentTimeMillis()
		List <Species> batch =[]
		species.each {
			batch.add(it);
			if(batch.size()>BATCH_SIZE){
				noOfInsertions += saveSpeciesBatch(batch);
				batch.clear();
				return
			}
		}
		if(batch.size() > 0) {
			noOfInsertions += saveSpeciesBatch(batch);
			batch.clear();
		}
		log.debug "Time taken to save : "+(( System.currentTimeMillis()-startTime)/1000) + "(sec)"

		//log.debug "Publishing to search index"
		def searchIndexManager = new SearchIndexManager();
		try {
			searchIndexManager.publishSearchIndex(species);
		} catch(e) {
			e.printStackTrace()
		}
		
		try{
			groupHandlerService.loadGroups(grailsApplication.config.speciesPortal.data.rootDir+"/templates/Groups.xlsx", 0, 0);
		} catch(e) {
			e.printStackTrace()
		}
		
		try{
			namesLoaderService.syncNamesAndRecos(false);
		} catch(e) {
			e.printStackTrace()
		}
		return noOfInsertions;
	}

	/**
	 * 
	 * @param batch
	 * @return
	 */
	private int saveSpeciesBatch(List<Species> batch) {
		int noOfInsertions = 0;
		Species.withTransaction {
			for(Species s in batch) {
				if(!s.save()) {
					s.errors.allErrors.each { log.error it }
				} else {
					noOfInsertions++;
				}
			}
		}
		log.debug "Saved batch with insertions : "+noOfInsertions
		//TODO : probably required to clear hibernate cache
		//Reference : http://naleid.com/blog/2009/10/01/batch-import-performance-with-grails-and-mysql/
		return noOfInsertions;
	}

	/**
	 *
	 */
	def createSpeciesStub(TaxonomyDefinition taxonConcept) {
		if(!taxonConcept) return;

		XMLConverter converter = new XMLConverter();

		Species s = new Species();
		s.taxonConcept = taxonConcept
		s.title = s.taxonConcept.italicisedForm;
		s.guid = converter.constructGUID(s);

		Species existingSpecies = converter.findDuplicateSpecies(s);
		if(!existingSpecies) {
			saveSpecies([s]);
		}
		return s;
	}

}