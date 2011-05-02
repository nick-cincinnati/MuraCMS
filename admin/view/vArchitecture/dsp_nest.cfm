<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. ÔøΩSee the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. ÔøΩIf not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes
the preparation of a derivative work based on Mura CMS. Thus, the terms and 	
conditions of the GNU General Public License version 2 (ÔøΩGPLÔøΩ) cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission
to combine Mura CMS with programs or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, ÔøΩthe copyright holders of Mura CMS grant you permission
to combine Mura CMS ÔøΩwith independent software modules that communicate with Mura CMS solely
through modules packaged as Mura CMS plugins and deployed through the Mura CMS plugin installation API,
provided that these modules (a) may only modify the ÔøΩ/trunk/www/plugins/ directory through the Mura CMS
plugin installation API, (b) must not alter any default objects in the Mura CMS database
and (c) must not alter any files in the following directories except in cases where the code contains
a separately distributed license.

/trunk/www/admin/
/trunk/www/tasks/
/trunk/www/config/
/trunk/www/requirements/mura/

You may copy and distribute such a combined work under the terms of GPL for Mura CMS, provided that you include
the source code of that other code when and as the GNU GPL requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception
for your modified version; it is your choice whether to do so, or to make such modified version available under
the GNU General Public License version 2 ÔøΩwithout this exception. ÔøΩYou may, if you choose, apply this exception
to your own modified versions of Mura CMS.
--->

<cfsilent>
<cfparam name="attributes.parentid" default="00000000000000000000000000000000001">
<cfparam name="attributes.locking" default="none">
<cfparam name="rsNext.recordcount" default=0>

<cfif attributes.nestlevel neq 1><cfset variables.startrow=1><cfelse><cfset variables.startrow=attributes.startrow></cfif>
<cfset sortable=attributes.nestlevel eq  1 and attributes.sortby eq 'orderno'>
<cfset currentPos=variables.startrow>
<cfset endRow=iif((currentPos + attributes.nextn) gt attributes.rsnest.recordcount,attributes.rsnest.recordcount,currentPos + attributes.nextn)>
</cfsilent>
<!--- Start Level UL List--->
<ul<cfif sortable> id='sortableKids'</cfif>>
<cfoutput query="attributes.rsNest" startrow="#variables.startrow#" maxrows="#attributes.nextN#">
<cfsilent><cfset request.menulist=listappend(request.menulist,attributes.rsnest.contentid)>
<cfif attributes.rsnest.hasKids> 
<cfset rsNext=application.contentManager.getNest(attributes.rsNest.contentid,attributes.siteid,attributes.rsNest.sortBy,attributes.rsNest.sortDirection)>
<cfset isMore=rsNext.recordcount gt attributes.nextN>
<cfelse>
<cfset isMore=false />
</cfif>


<cfset verdict=application.permUtility.getPerm(attributes.rsNest.contentid, attributes.siteid)>

<cfif verdict neq 'deny'>
	<cfif verdict eq 'none'>
		<cfset verdict=attributes.perm>
	</cfif>
<cfelse>
	<cfset verdict = "none">
</cfif>

<cfif attributes.locking neq 'all' and verdict neq 'none'>
	<cfset newcontent=1>
<cfelse>
	<cfset newcontent=0>
</cfif>

<cfset attop=attributes.rsnest.currentrow eq 1>

<cfset atbottom=attributes.rsnest.currentrow eq attributes.rsnest.recordcount>
	
<cfset neworder= ((attributes.parentid neq '00000000000000000000000000000000001' and attributes.locking neq 'all') or (attributes.parentid eq '00000000000000000000000000000000001' and attributes.locking eq 'none')) and attributes.perm eq 'editor'>

<cfset deletable=(((attributes.parentid neq '00000000000000000000000000000000001' and attributes.locking neq 'all') or (attributes.parentid eq '00000000000000000000000000000000001' and attributes.locking eq 'none')) and (verdict eq 'editor'))  and attributes.rsnest.IsLocked neq 1>


<cfif (attributes.restricted or attributes.rsNest.restricted)>
<cfset variables.restricted=1>
<cfelse>
<cfset variables.restricted=0>
</cfif>

<cfif attributes.rsNest.type eq 'File'>
	<cfset icon=lcase(attributes.rsNest.fileExt)>
	<cfif variables.restricted>
		<cfset icon=icon & "Locked">
	</cfif>
<cfelse>
	<cfset icon=attributes.rsNest.type>
	<cfif variables.restricted>
		<cfset icon="#icon#Locked">
	</cfif>
	<cfset icon=icon & " " & attributes.rsNest.subtype>
</cfif>

<cfset request.rowNum=request.rowNum+1>
</cfsilent>
<!--- Start LI for content Item --->
<li>
<dl>
<dt>
<!---<cfif (attributes.rsNest.type eq 'Page') or  (attributes.rsNest.type eq 'Portal')  or  (attributes.rsNest.type eq 'Calendar') or (attributes.rsNest.type eq 'Gallery')>--->
<a class="add" href="javascript:;" onmouseover="showMenu('newContentMenu',#newcontent#,this,'#attributes.rsNest.contentid#','#attributes.topid#','#attributes.rsNest.parentid#','#attributes.siteid#','#attributes.rsNest.type#');"></a>
	
	<cfif attributes.rsNest.haskids><span class="hasChildren" onclick="location.href='?fuseaction=cArch.list&siteid=#JSStringFormat(attributes.siteID)#&moduleid=#JSStringFormat(attributes.moduleID)#&topid=#JSStringFormat(attributes.rsNest.contentID)#';"></span></cfif>
	
	<cfsilent>
		<cfset draftPromptData = application.contentManager.getDraftPromptData(attributes.rsNest.contentid,attributes.siteid) />
	</cfsilent>
	
	<cfif verdict neq 'none'>
		<a class="#icon# title" data-showdialog="#draftPromptData.showdialog#" data-contentid="#attributes.rsNest.contentid#" data-historyid="#draftPromptData.historyID#" data-publishedHistoryID="#draftPromptData.publishedHistoryID#" title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.edit")#" href="index.cfm?fuseaction=cArch.edit&contenthistid=#attributes.rsNest.ContentHistID#&contentid=#attributes.rsNest.ContentID#&type=#attributes.rsNest.type#&parentid=#attributes.rsNest.parentID#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&startrow=#attributes.startrow#">
	<cfelse>
		<a class="#icon# title" data-showdialog="#draftPromptData.showdialog#" data-contentid="#attributes.rsNest.contentid#" data-historyid="#draftPromptData.historyID#" data-publishedHistoryID="#draftPromptData.publishedHistoryID#">
	</cfif>
		#HTMLEditFormat(left(attributes.rsNest.menutitle,70))#
		<cfif len(attributes.rsNest.menutitle) gt 70>&hellip;</cfif>
		<cfif isMore><span class="hasMore">&nbsp;(#application.rbFactory.getKeyValue(session.rb,"sitemanager.more")#)</span></cfif></a>
		<div class="mura-title-fade"></div>
</dt>	

<cfif attributes.locking neq 'all'>
	<dd class="objects">#attributes.rsNest.inheritObjects#</dd> 
	<dd class="display<cfif attributes.rsNest.Display eq 2 and attributes.rsNest.approved> scheduled</cfif>">
		<cfif attributes.rsNest.Display eq 1 and attributes.rsNest.approved>
			#application.rbFactory.getKeyValue(session.rb,"sitemanager.yes")#
		<cfelseif attributes.rsNest.Display eq 2 and attributes.rsNest.approved>
			<a href="##" class="tooltip"><span>#LSDateFormat(attributes.rsNest.displaystart,"short")#&nbsp;-&nbsp;#LSDateFormat(attributes.rsNest.displaystop,"short")#</span></a>
		<cfelse>
			#application.rbFactory.getKeyValue(session.rb,"sitemanager.no")#
		</cfif>
	</dd>
	 <dd class="feature<cfif attributes.rsNest.isfeature eq 2> scheduled</cfif>">
		<cfif attributes.rsNest.isfeature eq 1>
			#application.rbFactory.getKeyValue(session.rb,"sitemanager.yes")#
		<cfelseif attributes.rsNest.isfeature eq 2>
			<a href="##" class="tooltip"><span>#LSDateFormat(attributes.rsNest.featurestart,"short")#&nbsp;-&nbsp;#LSDateFormat(attributes.rsNest.featurestop,"short")#</span></a>
		<cfelse>
			#application.rbFactory.getKeyValue(session.rb,"sitemanager.no")#
		</cfif>
	</dd> 
</cfif>
	<dd class="nav">#application.rbFactory.getKeyValue(session.rb,"sitemanager.#yesnoformat(attributes.rsNest.isNav)#")#</dd>
    <dd class="updated">#LSDateFormat(attributes.rsnest.lastupdate,session.dateKeyFormat)# #LSTimeFormat(attributes.rsnest.lastupdate,"medium")#</dd>
    <dd class="admin">
    <ul>
    	<cfif verdict neq 'none'>
       <li class="edit"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.edit")#" href="index.cfm?fuseaction=cArch.edit&contenthistid=#attributes.rsNest.ContentHistID#&contentid=#attributes.rsNest.ContentID#&type=#attributes.rsNest.type#&parentid=#attributes.rsNest.parentID#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&startrow=#attributes.startrow#">&nbsp;</a></li>
	   <cfswitch expression="#attributes.rsnest.type#">
		<cfcase value="Page,Portal,Calendar,Gallery">
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,attributes.rsNest.filename)#','#attributes.rsnest.targetParams#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#</a></li>
		</cfcase>
		<cfcase value="Link">
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="javascript:preview('#attributes.rsnest.filename#','#attributes.rsnest.targetParams#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#</a></li>
		</cfcase>
		<cfcase value="File">
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,"")#?LinkServID=#attributes.rsnest.contentid#','#attributes.rsnest.targetParams#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#</a></li>
		</cfcase>
		</cfswitch>
	   <li class="versionHistory"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.versionhistory")#" href="index.cfm?fuseaction=cArch.hist&contentid=#attributes.rsNest.ContentID#&type=#attributes.rsNest.type#&parentid=#attributes.rsNest.parentID#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&startrow=#attributes.startrow#">&nbsp;</a></li>
        <cfif listFind(session.mura.memberships,'Admin;#application.settingsManager.getSite(attributes.siteid).getPrivateUserPoolID()#;0') or listFind(session.mura.memberships,'S2')>
          <li class="permissions"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.permissions")#" href="index.cfm?fuseaction=cPerm.main&contentid=#attributes.rsNest.ContentID#&type=#attributes.rsNest.type#&parentid=#attributes.rsNest.parentID#&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&startrow=#attributes.startrow#">&nbsp;</a></li>
        <cfelse>
		  <li class="permissionsOff"><a>#application.rbFactory.getKeyValue(session.rb,"sitemanager.permissions")#</a></li>
		</cfif>
        <cfif deletable>
          <li class="delete"><a  title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.delete")#" href="index.cfm?fuseaction=cArch.update&contentid=#attributes.rsNest.ContentID#&type=#attributes.rsNest.type#&action=deleteall&topid=#URLEncodedFormat(attributes.topid)#&siteid=#URLEncodedFormat(attributes.siteid)#&moduleid=#attributes.moduleid#&parentid=#URLEncodedFormat(attributes.parentid)#&startrow=#attributes.startrow#" onclick="return confirmDialog('#jsStringFormat(application.rbFactory.getResourceBundle(session.rb).messageFormat(application.rbFactory.getKeyValue(session.rb,'sitemanager.content.deletecontentrecursiveconfirm'),attributes.rsNest.menutitle))#',this.href)">&nbsp;</a></li>
          <cfelseif attributes.locking neq 'all'>
          <li class="deleteOff"><a>#application.rbFactory.getKeyValue(session.rb,"sitemanager.delete")#</a></li>
        </cfif>
        <cfelse>
        <li class="editOff"><a>&nbsp;</a></li>
		<cfswitch expression="#attributes.rsnest.type#">
		<cfcase value="Page,Portal,Calendar,Gallery">
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,attributes.rsNest.filename)#','#attributes.rsnest.targetParams#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#</a></li>
		</cfcase>
		<cfcase value="Link">
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="javascript:preview('#attributes.rsnest.filename#','#attributes.rsnest.targetParams#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#</a></li>
		</cfcase>
		<cfcase value="File">
		<li class="preview"><a title="#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#" href="javascript:preview('http://#application.settingsManager.getSite(attributes.siteid).getDomain()##application.configBean.getServerPort()##application.configBean.getContext()##application.contentRenderer.getURLStem(attributes.siteid,"")#?LinkServID=#attributes.rsnest.contentid#','#attributes.rsnest.targetParams#');">#application.rbFactory.getKeyValue(session.rb,"sitemanager.view")#</a></li>
		</cfcase>
		</cfswitch>
		<li class="versionHistoryOff"><a>#application.rbFactory.getKeyValue(session.rb,"sitemanager.versionhistory")#</a></li>
		<li class="permissionsOff"><a>#application.rbFactory.getKeyValue(session.rb,"sitemanager.permissions")#</a></li>
		<li class="deleteOff"><a>#application.rbFactory.getKeyValue(session.rb,"sitemanager.delete")#</a></li>
      </cfif>
		<cfif  ListFindNoCase("Page,Portal,Calendar,Link,File,Gallery",attributes.rsNest.type)>
		#application.pluginManager.renderScripts("onContentList",attributes.siteid,attributes.pluginEvent)#
		</cfif>
		#application.pluginManager.renderScripts("on#attributes.rsNest.type#List",attributes.siteid,attributes.pluginEvent)#
		#application.pluginManager.renderScripts("on#attributes.rsNest.type##attributes.rsNest.subtype#List",attributes.siteid,attributes.pluginEvent)#
	</ul>
	</dd>
</dl>
   <cfif attributes.rsNest.hasKids and attributes.nestlevel lt attributes.viewDepth>
   <cf_dsp_nest parentid="#attributes.rsNest.contentid#"  
   locking="#attributes.locking#" 
   nestlevel="#evaluate(attributes.nestlevel + 1)#" 
   perm="#verdict#"
   siteid="#attributes.siteid#"
   topid="#attributes.topid#"
   rsnest="#rsNext#"
   moduleid="#attributes.moduleid#"
   restricted="#variables.restricted#"
   viewdepth="#attributes.viewDepth#"
   nextn="#attributes.nextN#"
   startrow="#attributes.startrow#"
   sortBy="#attributes.sortBy#"
   pluginEvent="#attributes.pluginEvent#">
   </cfif>
   <cfset currentPos=currentPos+1>
   <cfif sortable>
   		<input type="hidden" name="orderid" value="#attributes.rsnest.contentID#"/>
   </cfif>
   <!--- Close LI for contentID--->
   </li>
   </cfoutput>
   <!--- Close UL --->
   </ul>