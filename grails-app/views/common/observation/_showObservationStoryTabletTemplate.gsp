<g:javascript>
    $(document).ready(function(){
        $(".observation_story").hover(function(){
                $('.more_info', this).slideDown('fast'); 
            },
            function(){
                $('.more_info', this).slideUp('fast'); 
            });
    });

</g:javascript>

<div class="observation_story tablet">
	<div class="observation-icons">
		<img class="species_group_icon"
			src="${createLinkTo(file: observationInstance.group.icon()?.fileName?.trim(), base:grailsApplication.config.speciesPortal.resources.serverURL)}"
			title="${observationInstance.group?.name}" />

		<g:if test="${observationInstance.habitat}">
			<img class="habitat_icon species_group_icon"
				src="${createLinkTo(dir: 'group_icons', file:'All.png', base:grailsApplication.config.speciesPortal.resources.serverURL)}"
				title="${observationInstance.habitat}" />
		</g:if>

	</div>

	<div class="prop tablet">
		<span class="name tablet">Species Name</span>
		<div class="value tablet">
			<obv:showSpeciesName model="['observationInstance':observationInstance]" />
		</div>
	</div>


	<div class="prop tablet">
		<span class="name tablet">Place name</span>
		<div class="value tablet">
			${observationInstance.placeName}
		</div>
	</div>

	<div class="prop tablet">
		<span class="name tablet">Lat/Long</span>
		<div class="value tablet">
			<g:formatNumber number="${observationInstance.latitude}"
				type="number" maxFractionDigits="2" />
			,
			<g:formatNumber number="${observationInstance.longitude}"
				type="number" maxFractionDigits="2" />
		</div>
	</div>
	<%--		<div class="prop tablet">--%>
	<%--			<span class="name tablet">Recommendations</span>--%>
	<%--			<div class="value tablet">--%>
	<%--				${observationInstance.getRecommendationCount()}--%>
	<%--			</div>--%>
	<%--		</div>--%>

	<div class="prop tablet">
		<span class="name tablet">Created on</span>
		<obv:showDate
			model="['observationInstance':observationInstance, 'propertyName':'createdOn']" />
	</div>


	<div class="prop tablet">
		<span class="name tablet">Last Update</span>
		<obv:showDate
			model="['observationInstance':observationInstance, 'propertyName':'lastUpdated']" />
	</div>

	<div class="prop tablet">
		<span class="name tablet">Visit Count</span>
		<div class="value tablet">
			${observationInstance.getPageVisitCount()}
		</div>
	</div>

	<sUser:showUserSnippet model="['userInstance':observationInstance.author]"/>



	<br />

	<div class="more_info"
		style="position: absolute; display: none; background-color: #fbfbfb; width: 200px; z-index: 2; box-shadow: 0 8px 6px -6px black;">
		<obv:showTagsSummary
			model="['observationInstance':observationInstance]" />
	</div>
</div>

