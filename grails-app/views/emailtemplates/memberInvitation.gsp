<%@ page contentType="text/html"%>

Hai ${member.name.capitalize()},
<br/><br/><br/>
<g:link controller="SUser" action="show" id="${fromUser.id }" absolute="true">${fromUser.name.capitalize()}</g:link> is inviting you to be a member in this interesting group <g:link controller="userGroup" action="show" id="${userGroupInstance.id }" absolute="true">${userGroupInstance.name}</g:link> on <b>${domain}</b>.
<br/> 

Please <a href="${uri}" title="Confirmation code">click here</a> to confirm the invitation.
<br/><br/><br/>
Thank you,<br/>
The Portal Team