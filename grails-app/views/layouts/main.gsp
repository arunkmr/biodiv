<!DOCTYPE html>
<%@page import="org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils"%>
<html lang="en" xmlns:fb="http://ogp.me/ns/fb#">
<head>
<title>Species Portal</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />


<g:if test="${params.controller != 'species'}">
<link rel="stylesheet" type="text/css" media="all"
	href="${resource(dir:'bootstrap/css',file:'bootstrap.css', absolute:true)}" />
</g:if>        
<g:else>

<link rel="stylesheet" type="text/css" media="all"
	href="${resource(dir:'css',file:'forSpeciesPages.css', absolute:true)}" />

</g:else>

<!--link rel="stylesheet" type="text/css" media="all"
	href="${resource(dir:'bootstrap/css',file:'bootstrap-responsive.css', absolute:true)}" /-->

<link rel="stylesheet" type="text/css" media="all"
	href="${resource(dir:'css',file:'jquery-ui.css', absolute:true)}" />

<!-- r:require module="jquery-ui" /-->

<!-- r:layoutResources /-->
<!-- sNav:resources override="true" /-->

<script src="${resource(dir:'plugins',file:'jquery-1.7/js/jquery/jquery-1.7.min.js', absolute:true)}" type="text/javascript" ></script>

<g:if test="${params.controller  != 'species'}">
<g:javascript src="bootstrap.js"
	base="${grailsApplication.config.grails.serverURL+'/bootstrap/js/'}"></g:javascript>
</g:if>
<script src="${resource(dir:'plugins',file:'jquery-ui-1.8.15/jquery-ui/js/jquery-ui-1.8.15.custom.min.js', absolute:true)}" type="text/javascript" ></script>

<link rel="stylesheet" type="text/css" media="screen"
	href="${resource(dir:'js/jquery/jquery.jqGrid-4.1.2/css',file:'ui.jqgrid.css', absolute:true)}" />

<!-- link rel="stylesheet" type="text/css"
	href="${resource(dir:'css',file:'auth.css', absolute:true)}" /-->
	<link rel="stylesheet" media="screen" href="${resource(dir:'css',file:'spring-security-ui.css',plugin:'spring-security-ui')}"/>
	<link rel="stylesheet" media="screen" href="${resource(dir:'css',file:'jquery.jgrowl.css',plugin:'spring-security-ui')}"/>
	<link rel="stylesheet" media="screen" href="${resource(dir:'css',file:'jquery.safari-checkbox.css',plugin:'spring-security-ui')}"/>
	<link rel="stylesheet" media="screen" href="${resource(dir:'css',file:'auth.css',plugin:'spring-security-ui')}"/>
	<link rel="stylesheet" media="screen" href="${resource(dir:'css',file:'date_input.css',plugin:'spring-security-ui')}"/>
   <link rel="stylesheet" media="screen" href="${resource(dir:'css',file:'jquery.jdMenu.css',plugin:'spring-security-ui')}"/>
   <link rel="stylesheet" media="screen" href="${resource(dir:'css',file:'jquery.jdMenu.slate.css',plugin:'spring-security-ui')}"/>
   <link rel="stylesheet" media="screen" href="${resource(dir:'css',file:'table.css',plugin:'spring-security-ui')}"/>
	
<link rel="stylesheet" type="text/css" media="all"
	href="${resource(dir:'css',file:'reset.css', absolute:true)}" />
<link rel="stylesheet" type="text/css" media="all"
	href="${resource(dir:'css',file:'text.css', absolute:true)}" />
        

<link rel="stylesheet" type="text/css" media="all"
	href="${resource(dir:'css',file:'960.css', absolute:true)}" />
<g:if test="${params.controller == 'species'}">
<link rel="stylesheet"
	href="${resource(dir:'css',file:'main.css', absolute:true)}" />
</g:if>    
    
<link rel="stylesheet" type="text/css"
	href="${resource(dir:'css',file:'navigation.css', absolute:true)}" />
<link rel="stylesheet" type="text/css" media="all"
	href="${resource(dir:'css',file:'jquery.rating.css', absolute:true)}" />
<link rel="stylesheet" type="text/css" media="all"
	href="${resource(dir:'css',file:'wgp.css', absolute:true)}" />

<g:javascript src="jquery/jquery.form.js"
	base="${grailsApplication.config.grails.serverURL+'/js/'}"></g:javascript>
<g:javascript src="jquery/jquery.rating.js"
	base="${grailsApplication.config.grails.serverURL+'/js/'}"></g:javascript>
<g:javascript src="readmore/readmore.js"
	base="${grailsApplication.config.grails.serverURL+'/js/'}" />
<g:javascript src="jquery.cookie.js"
	base="${grailsApplication.config.grails.serverURL+'/js/jquery/'}"></g:javascript>

<g:javascript src='jquery/jquery.jgrowl.js' plugin='spring-security-ui'/>
<g:javascript src='jquery/jquery.checkbox.js' plugin='spring-security-ui'/>
<g:javascript src='spring-security-ui.js' plugin='spring-security-ui'/>

<g:javascript>
jQuery(document).ready(function($) {
        if (document.domain == "${grailsApplication.config.wgp.domain}"){
            $('#ibp_header').hide();
            $('#wgp_header').show();
        }

        if (document.domain == "${grailsApplication.config.ibp.domain}"){
            $('#wgp_header').hide();
            $('#ibp_header').show();
        }


	$("#menu .navigation li").hover(
  		function () {
    		$(".subnavigation", this).show();
  		}, 
  		function () {
    		$(".subnavigation", this).hide();
  		}
	);
	$.widget( "custom.catcomplete", $.ui.autocomplete, {
					_renderMenu: function( ul, items ) {
						var self = this,
							currentCategory = "";
						$.each( items, function( index, item ) {
							if ( item.category != currentCategory ) {
								ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
								currentCategory = item.category;
							}
							self._renderItem( ul, item );
						});
					}
				});
});
</g:javascript>

<g:layoutHead />
<ga:trackPageview />

<!-- script src="http://cdn.wibiya.com/Toolbars/dir_1100/Toolbar_1100354/Loader_1100354.js" type="text/javascript"></script><noscript><a href="http://www.wibiya.com/">Web Toolbar by Wibiya</a></noscript--> 

<style>
#header {
    background-color: #F7F7F7;
    height: 80px;
    width: 100%;
    z-index: 2000;
    font-family: Verdana,Helvetica,Sans-Serif;
    color: #5E5E5E;
    box-shadow: 0 6px 6px -6px #5E5E5E;       
    border-bottom:1px solid #E5E5E5;
}
#wg_logo {
    border: 0 none;
    height: 80px;
    width: auto;
}
#top_nav_bar {
    font-size: 1em;
    font-weight: bold;
    left: 300px;
    position: absolute;
    top: 30px;
    z-index: 501;
}
#top_nav_bar ul {
    list-style: none outside none;
    margin-top:14px;
    margin-bottom:14px;
    font-size: 1.1em;
    padding-left: 40px;
}
#top_nav_bar li {
    cursor: pointer;
    display: inline;
    padding: 10px 10px 3px;
}
#top_nav_bar li:hover{
background-color: #e8f7f1;
border-bottom:3px solid #003846;
}

</style>
	<g:javascript>

		
		
	</g:javascript>

</head>
<body>
	<!-- div id="spinner" class="spinner" style="display:none;">
		<img src="${resource(dir:'images',file:'spinner.gif', absolute:true)}"
			alt="${message(code:'spinner.alt',default:'Loading...')}" />
	</div-->
	
	<div id="loading" class="loading" style="display:none;">
		<span>Loading ...</span>
	</div>
       
        <div id="wgp_header" style="display:none;">
            <domain:showWGPHeader/>
        </div>    

        <div id="ibp_header" style="display:none;">
            <domain:showIBPHeader/>
        </div>    


	
	<div id="species_main_wrapper">
	
		<div class="container_12 container">
			<div id="menu" class="grid_12 ui-corner-all" style="margin-bottom:10px;">
				<div class="demo" style="float: right; margin-right: .3em;"
					title="These are demo pages">These are demo pages</div><br/>
				
                                <g:if test="${params.controller == 'species' || params.controller == 'search'}">
				    <sNav:render group="species_dashboard" subitems="false" />
                                </g:if>    
                                <g:if test="${params.controller == 'observation'}">
				    <sNav:render group="observation_dashboard" subitems="false" />
                                </g:if>    
				
				<div style="float: right;">
					<g:searchBox />
				</div>
				
			</div>
			
		</div>
		<g:layoutBody />
                <!--div class="page-footer"></div-->
	</div>

	<g:javascript>

		$(document).ready(function(){
                       
                     
			$('.rating').each(function(){
				$('.star', $(this)).rating({
							callback: function(value, link){
								//alert(value);
								//$(this.form).ajaxSubmit();
							}
						});
			});
		
			var offset = $('#loginLink').offset();
			if(offset) {
				$('#ajaxLogin').offset({left:offset.left-$('#ajaxLogin').width()+$('#loginLink').width(), top:offset.top});
			}
	   		var options = { 
	   		 	type:'POST', 
		        dataType: 'json',
		        beforeSubmit:  function (formData, jqForm, options) {
		        	return true; 
		        },  
		        success:  function (json, statusText, xhr, $form)  {
			       	 if (json.success) {
			            $('#ajaxLogin').hide();
			            $('#loginLink').html('Logged in as ' + json.username + ' (<%=link(controller: 'logout') { 'Logout' }%>)');
			         }
			         else if (json.error) {
			            $('#loginMessage').html("<span class='errorMessage'>" + json.error + '</error>'); } else { $('#loginMessage').html(responseText);
					} 
				}
			};
			
			// bind form using 'ajaxForm' var form =
			$('#ajaxLoginForm').ajaxForm(options);
			
			$('#spinner')
				.hide()  // hide it initially
    			.ajaxStart(function() { 
    				$("html").addClass('busy');
    				$(this).offset({left:($('body').width()/2), top:($('body').height()/2)});
        			$(this).show();
    			})
    			.ajaxStop(function() {
    				$("html").removeClass('busy');
        			$(this).hide();
    			});
    		
				$(".ui-icon-control").click(function() {
					var div = $(this).siblings("div.toolbarIconContent");
					if (div.is(":visible")) {
						div.hide(400);
					} else {
						div.slideDown("slow");	
						// div.css("float","right");
						if(div.offset().left < 0) {
							div.offset({left:div.parent().offset().left});					
						}
					}
				});
			
				$(".ui-icon-edit").click(function() {
					var ele =$(this).siblings("div.toolbarIconContent").find("textArea.fieldEditor");
					if(ele) { 
						ele.ckeditor(function(){}, {customConfig:"${resource(dir:'js',file:'ckEditorConfig.js', absolute:true)}"});
						CKEDITOR.replace( ele.attr('id') );
					}
				});
			
				$("a.ui-icon-close").click(function() {
					$(this).parent().hide("slow");
				});
				

							
	
				// make sure facebook is initialized before calling the facebook JS api
				window.fbEnsure = function(callback) {
  					if (window.facebookInitialized) { callback(); return; }
					  FB.init({
						appId  : '${SpringSecurityUtils.securityConfig.facebook.appId}',
					    channelUrl : "${grailsApplication.config.grails.serverURL}/channel.html",
					    status : true,
					    cookie : true,
					    xfbml: true,
					    oauth  : true,
					    logging : true
					  }); 
					  
					  window.facebookInitialized = true;
					  callback();
				};
				
				/**
				 * Just connect (for logged in users) to facebook and reassociate the user
				 * (and possibly get the facebook profile picture if no avatar yet set).
				 * Triggers two events on the '.fbJustConnect' element:
				 * - "connected" will be triggered if the reassociation was successful
				 * - "failed" will be triggered when for whatever reason the coupling was unsuccessful
				 */
				var fbConnect = function() {
										
					var scope = { scope: "" };
					scope.scope = "email,user_about_me,user_location,user_activities,user_hometown,manage_notifications,user_website,publish_stream";
					
					fbEnsure(function() {
						FB.login(function(response) {
							if (response.status == 'connected') {
								window.location = "${createLink(controller:'login', action:'authSuccess')}"+"?uid="+response.authResponse.userID
							} else {
								alert("Failed to connect to Facebook");
							}
						}, scope);
					});
				};
				
				$('.fbJustConnect').click(function() {
					fbConnect();
				});
				
		}); 

			function show_login_dialog() {
				$('#ajaxLogin').show(); 
			} 

			
			function cancelLogin() {
				$('#ajaxLogin').hide(); 
			}

			function authAjax() { 
				$('#loginMessage').val('Sending request ...');
				$('#loginMessage').show(); 
				$('#ajaxLoginForm').submit(); 
			}
			if (typeof(console) == "undefined") { console = {}; } 
			if (typeof(console.log) == "undefined") { console.log = function() { return 0; } }
			
</g:javascript>	
	<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=${SpringSecurityUtils.securityConfig.facebook.appId}";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>
	
</body>
</html>
