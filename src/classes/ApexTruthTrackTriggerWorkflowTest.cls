@isTest
private class ApexTruthTrackTriggerWorkflowTest {

    /**
     * After a record is inserted where nothing special happens other
     * than the Set Num Workflow Touches workflow rule, the key fields
     * on the Apex truth should show the following.
     *
     * - 1 DML operation
     * - 1 workflow touch
     * - 2 trigger touches, with the 2nd one occurring as a result
     *   of the Num Workflow Touches field update being executed
     */
    @isTest
    private static void validateAutomationCounters() {

        // Define parameters for the test
        ApexTruth__c truth = new ApexTruth__c(Name = 'Iron Man (TEST)');

        // Run the test
        Test.startTest();

        insert truth;

        // Validate results
        truth = [
            SELECT
                NumberOfDmlOperations__c,
                NumberOfWorkflowTouches__c,
                NumberOfTriggerTouches__c
            FROM ApexTruth__c
            WHERE Id = :truth.Id
        ];

        System.assertEquals(1, truth.NumberOfWorkflowTouches__c,
                ApexTruth__c.fields.NumberOfWorkflowTouches__c.getDescribe().getLabel());

        // Fourteen touches!? Here's the breakdown.
        // 
        // 1.  before insert
        // 2.  before update, caused by workflow field update
        // 3.  before update, caused by ApexTruthTrackProcess
        // 4.  before update, caused by ApexTruthTrackSecondaryProcess
        //
        // Touches 5-14 are basically the third and fourth touch repeated
        // five times, caused by process recursion. As Salesforce says,
        // "If you select yes [to recursion], this process can [re-evaluate]
        // the same record up to five times in a single transaction.
        // It might reevaluate the record because a process, workflow rule,
        // or flow updated the record in the same transaction."
        System.assertEquals(14, truth.NumberOfTriggerTouches__c,
                ApexTruth__c.fields.NumberOfTriggerTouches__c.getDescribe().getLabel());
    }
}