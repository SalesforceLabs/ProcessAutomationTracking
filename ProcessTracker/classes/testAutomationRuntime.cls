@isTest
	private class testAutomationRuntime {
	   /*
	Process Automation Tracking unmanaged package by Jessie Rymph. June 2019. More information 
	https://unhandledsunshine.com/2019/06/05/was-it-worth-my-time-to-automate-that/
	The purpose of this package is track how often your automations -workflow, process builder and apex - 
	are run, which in turn helps you determine how worth while it is to build each automation.
	
		Test Scenario:
		- A Process Automation record is created. 
        - The test class will launch the Flow and pass variables to it.
		

		Expected Result:
		- A new Automation Runtime record will be created.

		How:
		- Flow: Create Automation Runtime.
	*/
	static testMethod void LaunchFlow()
    {
         //create new Process Automation record
         //this object stores info about a workflow, process or apex class and is a parent record of Automation Runtime records.
        Process_Automation__c workflowRule = new Process_Automation__c( Name='Workflow Rule',Type__c = 'Workflow Rule');
        insert workflowRule;
        
        // Call the Flow
        // the Flow could normally be launched by apex, workflow or process builder.
        // pass in ID of the Process Automation record. 
        Map<String, Object> params = new Map<String, Object>();
        params.put('ProcessAutomationID', workflowRule.Id);
        params.put('Name', workflowRule.Name);
        Flow.Interview.Create_Automation_Runtime runFlow = new Flow.Interview.Create_Automation_Runtime(params);
        runFlow.start();
         
        // check that the Flow created a new Automation Runtime record.
        // look for an Automation Runtime record created who's Process Automation - parent record - is the Process Automation record created in the test.
        List <Automation_Runtime__c> autoRuns = [SELECT Id, Process_Automation__c FROM Automation_Runtime__c WHERE Process_Automation__c = :workflowRule.Id];
        System.assertEquals(workflowRule.Id,autoRuns[0].Process_Automation__c);
        System.debug('id of Process Automation equals ' + workflowRule.Id);
        System.debug('id of Automation Runtime equals ' + autoRuns[0].Id);
    }}