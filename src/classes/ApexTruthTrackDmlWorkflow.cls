global with sharing class ApexTruthTrackDmlWorkflow
        extends AbstractSobjectWorkflow {

    global override void executeAfter() {
        for (ApexTruth__c eachRecord : (List<ApexTruth__c>)this.records) {
            insert new Task(WhatId = eachRecord.Id, Subject = 'Track DML');
        }
    }

    global override void executeBefore() {
        for (ApexTruth__c eachRecord : (List<ApexTruth__c>)this.records) {
            eachRecord.NumberOfDmlOperations__c++;
        }
    }

    global override String getClassName() {
        return ApexTruthTrackDmlWorkflow.class.getName();
    }

    /**
     * Any time there's a DML operation we should be tracking that an operation
     * occurred.
     */
    global override Boolean qualify(Sobject newRecord, Sobject oldRecord) {
        return Trigger.isInsert || Trigger.isUpdate;
    }
}