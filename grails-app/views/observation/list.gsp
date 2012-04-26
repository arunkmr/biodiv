
<%@page import="species.auth.SUser"%>
<%@ page import="species.participation.Observation"%>
<%@ page import="species.groups.SpeciesGroup"%>
<%@ page import="species.Habitat"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="layout" content="main" />
<g:set var="entityName"
	value="${message(code: 'observation.label', default: 'Observations')}" />
<title><g:message code="default.list.label" args="[entityName]" />
</title>
<link rel="stylesheet"
	href="${resource(dir:'css',file:'tagit/tagit-custom.css')}"
	type="text/css" media="all" />
<script type="text/javascript"
	src="http://maps.google.com/maps/api/js?sensor=true"></script>
<g:javascript src="location/google/markerclusterer.js"></g:javascript>

<g:javascript src="tagit.js"></g:javascript>
<g:javascript src="jquery/jquery.autopager-1.0.0.js"></g:javascript>
</head>
<body>
	<div class="container outer-wrapper">
		<div class="row">
			<div class="span12">
				<div class="page-header">
					<h1>
						<g:message code="default.observation.heading" args="[entityName]" />
					</h1>
				</div>

				<g:if test="${flash.message}">
					<div class="message">
						${flash.message}
					</div>
				</g:if>

				<div class="filters" style="position: relative;">
					<obv:showGroupFilter
						model="['observationInstance':observationInstance]" />
					<div id="speciesNameFilter" class="btn-group"
						style="float: right; margin-right: 5px; z-index: 10; position: absolute; margin-top: -65px; right: 0;">
						<!-- input type="radio" name="speciesNameFilter"
												id="speciesNameFilter1" value="All" style="display: none" />
											<label for="speciesNameFilter1" value="All">All</label> <input
												type="radio" name="speciesNameFilter"
												id="speciesNameFilter2" value="Unknown"
												style="display: none" /> <label for="speciesNameFilter2"
												value="Unknown">Show Unidentified Only</label-->

						<input type="text" id="speciesNameFilter"
							value="${params.speciesName}" style="display: none" />
						<button id="speciesNameAllButton" class="btn" rel="tooltip"
							data-original-title="Show all observations">All</button>
						<button id="speciesNameFilterButton" class="btn" rel="tooltip"
							data-original-title="Show only unidentified observations">Unidentified</button>
					</div>
				</div>
				<div class="tags_section span3" style="float: right;">
					<obv:showAllTags model="['tagFilterByProperty':'All']" />
				</div>

				<div class="row">
					<!-- main_content -->
					<div class="list span9">

						<div class="observations thumbwrap">
							<div class="observation">
								<div>
									<obv:showObservationFilterMessage
										model="['observationInstanceTotal':observationInstanceTotal, 'queryParams':queryParams]" />
								</div>
								<div style="clear: both;"></div>

								<div id="map_view_bttn" class="btn-group">
									<a class="btn btn-success dropdown-toggle"
										data-toggle="dropdown" href="#"
										onclick="$(this).parent().css('background-color', '#9acc57'); showMapView(); return false;">
										Map view <span class="caret"></span>
									</a>
								</div>
								<div class="btn-group" style="float: left; z-index: 10">
									<button id="selected_sort" class="btn dropdown-toggle"
										data-toggle="dropdown" href="#" rel="tooltip"
										data-original-title="Sort by">
										<g:if test="${params.sort == 'visitCount'}">
                                               Most viewed
                                            </g:if>
										<g:elseif test="${params.sort == 'lastRevised'}">
                                                Last updated
                                            </g:elseif>
										<g:else>
                                                Latest
                                            </g:else>
										<span class="caret"></span>
									</button>

									<ul id="sortFilter" class="dropdown-menu" style="width: auto;">
										<li class="group_option"><a class=" sort_filter_label"
											value="createdOn"> Latest </a></li>
										<li class="group_option"><a class=" sort_filter_label"
											value="lastRevised"> Last Updated </a></li>
										<li class="group_option"><a class=" sort_filter_label"
											value="visitCount"> Most Viewed </a></li>
									</ul>


								</div>

								<div id="observations_list_map" class="observation"
									style="clear: both; display: none;">
									<obv:showObservationsLocation
										model="['observationInstanceList':totalObservationInstanceList]">
									</obv:showObservationsLocation>
								</div>
							</div>

							<obv:showObservationsList />
						</div>
					</div>



				</div>
				<!-- main_content end -->
			</div>
		</div>
	</div>
	<!--container end-->
	<g:javascript>	
        $(document).ready(function(){
        	$('#selected_sort').tooltip({placement:'right'});
            $('button').tooltip();
            $('.dropdown-toggle').dropdown();
            	
            $('#speciesNameFilter').button();
            if(${params.speciesName == 'Unknown' }){
				$("#speciesNameFilterButton").addClass('active')
				$("#speciesNameAllButton").removeClass('active')
			}else{
				$("#speciesNameFilterButton").removeClass('active')
				$("#speciesNameAllButton").addClass('active')
            }
        	
        	function stringTrim(s){
           		return s.replace(/^\s*/, "").replace(/\s*$/, "");
            }
           
           $("#speciesNameAllButton").click(function() {
           		if($("#speciesNameAllButton").hasClass('active')){
           			return false;
           		}
				$("#speciesNameFilter").val('All')
				$("#speciesNameFilterButton").removeClass('active')
				$("#speciesNameAllButton").addClass('active')
				
				updateGallery(undefined, ${queryParams.max}, 0);
                return false;
			});
			
			$("#speciesNameFilterButton").click(function() {
				if($("#speciesNameFilterButton").hasClass('active')){
           			return false;
           		}
			    $("#speciesNameFilter").val('Unknown')
				$("#speciesNameFilterButton").addClass('active')
			    $("#speciesNameAllButton").removeClass('active')
					
				updateGallery(undefined, ${queryParams.max}, 0);
                return false;
			});
			                
        	$('#speciesGroupFilter button').click(function(){
        		if($(this).hasClass('active')){
        			return false;
        		}
        		$('#speciesGroupFilter button.active').removeClass('active').css('backgroundPosition', '0px 0px');
            	$(this).addClass('active').css('backgroundPosition', '0px -64px');
            	updateGallery(undefined, ${queryParams.max}, 0);
            	return false;
         	});
                
         	$('#habitatFilter button').click(function(){
         		if($(this).hasClass('active')){
        			return false;
        		}
         		$('#habitatFilter button.active').removeClass('active').css('backgroundPosition', '0px 0px');
            	$(this).addClass('active').css('backgroundPosition', '0px -64px');
            	updateGallery(undefined, ${queryParams.max}, 0);
            	return false;
         	});
                
           $('.sort_filter_label').click(function(){
           		var caret = '<span class="caret"></span>'
           		if(stringTrim(($(this).html())) == stringTrim($("#selected_sort").html().replace(caret, ''))){
           			$("#sortFilter").hide()
                	return false;
        		}
        		$(this).addClass('active');
                $("#selected_sort").html($(this).html() + caret);
                $("#sortFilter").hide()
                updateGallery(undefined, ${queryParams.max}, 0);
                return false;   
           });

			$("#selected_sort").click(function(){
				$("#sortFilter").show();
			});
			
            function getSelectedGroup() {
                var grp = ''; 
                $('#speciesGroupFilter button').each (function() {
                        if($(this).hasClass('active')) {
                                grp += $(this).attr('value') + ',';
                        }
                });

                grp = grp.replace(/\s*\,\s*$/,'');
                return grp;	
            } 
                
            function getSelectedHabitat() {
                var hbt = ''; 
                $('#habitatFilter button').each (function() {
                        if($(this).hasClass('active')) {
                                hbt += $(this).attr('value') + ',';
                        }
                });
                hbt = hbt.replace(/\s*\,\s*$/,'');
                return hbt;	
            } 
                
            function getSelectedSortBy() {
                var sortBy = ''; 
                 $('.sort_filter_label').each (function() {
                        if($(this).hasClass('active')) {
	                        sortBy += $(this).attr('value') + ',';
                        }
                });

                sortBy = sortBy.replace(/\s*\,\s*$/,'');
                return sortBy;	
            } 
                
            function getSelectedSpeciesName() {
                var sName = ''; 
				sName = $("#speciesNameFilter").attr('value');
				if(sName) {
                	sName = sName.replace(/\s*\,\s*$/,'');
                	return sName;
                }	
            } 

            function getFilterParameters(url, limit, offset) {
                            
                    var params = url.param();

                    var sortBy = getSelectedSortBy();
                    if(sortBy) {
                            params['sort'] = sortBy;
                    }

                    var sName = getSelectedSpeciesName();
                    if(sName) {
                            params['speciesName'] = sName;
                    }

                    var grp = getSelectedGroup();
                    if(grp) {
                            params['sGroup'] = grp;
                    }

                    var habitat = getSelectedHabitat();
                    if(habitat) {
                            params['habitat'] = habitat;
                    }

                    if(limit != undefined) {
                        params['max'] = limit.toString();
                    }

                    if(offset != undefined) {
                        params['offset'] = offset.toString();
                    }

                    return params;
                }	
                
                function updateGallery(target, limit, offset) {
                    if(target === undefined) {
                            target = window.location.pathname + window.location.search;
                    }
                    
                    var a = $('<a href="'+target+'"></a>');
                    var url = a.url();
                    var href = url.attr('path');
                    var params = getFilterParameters(url, limit, offset);
                    params["isGalleryUpdate"] = true;
                    var recursiveDecoded = decodeURIComponent($.param(params));
                    
                    var doc_url = href+'?'+recursiveDecoded;
                    
                   	$.ajax({
  						url: doc_url,
  						dataType: 'json',
  						
  						beforeSend : function(){
  							$('.observations_list').css({"opacity": 0.5});
  						},
  						
  						success: function(data){
  							$('.observations_list').replaceWith(data.obvListHtml);
  							$('#info-message').replaceWith(data.obvFilterMsgHtml);
						},
						statusCode: {
	    					401: function() {
	    						show_login_dialog();
	    					}	    				    			
	    				},
	    				error: function(xhr, status, error) {
	    					var msg = $.parseJSON(xhr.responseText);
	    					$('.message').html(msg);
						}
					});
                }
                
                $('#speciesNameFilter input').change(function(){
                    updateGallery(undefined, ${queryParams.max}, 0);
                    return false;
                });
        
                
                $(".paginateButtons a").click(function() {
                    updateGallery($(this).attr('href'));
                    return false;
                });
                
                $("ul[name='tags']").tagit({select:true,  tagSource: "${g.createLink(action: 'tags')}"});
         
                $("li.tagit-choice").click(function(){
                    var tg = $(this).contents().first().text();
                    window.location.href = "${g.createLink(action: 'list')}/?tag=" + tg ;
                });
               
                /*
                $(".snippet.tablet").live('hover', function(e){
                    if(e.type == 'mouseenter'){    
                        $(".figure", this).slideUp("fast");   
                        $(".all_content", this).hide();   
                        $('.observation_info_wrapper', this).slideDown("fast"); 
                    }
                
                    if(e.type == 'mouseleave'){    
                        $(".figure", this).slideDown("fast");   
                        $(".all_content", this).show();   
                        $('.observation_info_wrapper', this).slideUp("fast"); 
                    }


                   });
                 */  

            });
        </g:javascript>
	<script>
		function showMapView() {
			$('#observations_list_map').slideToggle(function() {

				if ($(this).is(':hidden')) {
					$('div.observations > div.observations_list').show();
					$('#map_view_bttn').css('background-color', 'transparent');
				} else {
					$('div.observations > div.observations_list').hide();
				}

				google.maps.event.trigger(big_map, 'resize');
				big_map.setCenter(nagpur_latlng);
			});
		}
	</script>
</body>
</html>
