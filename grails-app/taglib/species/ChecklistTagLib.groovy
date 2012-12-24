package species

class ChecklistTagLib {
	static namespace = "clist"
	
	def showFilteredCheckList = {attrs, body->
		out << render(template:"/common/checklist/showFilteredChecklistTemplate", model:attrs.model);
	}

	def showChecklistLocation= {attrs, body->
		out << render(template:"/common/checklist/showChecklistMultipleLocationTemplate", model:attrs.model);
	}
	
	def showSnippet= {attrs, body->
		out << render(template:"/common/checklist/showChecklistSnippetTabletTemplate", model:attrs.model);
	}
	
	def showData= {attrs, body->
		out << render(template:"/common/checklist/showChecklistDataTemplate", model:attrs.model);
	}
	
	def showChecklistMsg= {attrs, body->
		out << render(template:"/common/checklist/showChecklistMsgTemplate", model:attrs.model);
	}
	
	def showList = {attrs, body->
		out << render(template:"/common/checklist/showChecklistListTemplate", model:attrs.model);
	}
}