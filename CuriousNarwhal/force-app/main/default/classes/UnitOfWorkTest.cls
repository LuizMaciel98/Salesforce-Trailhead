@isTest
public class UnitOfWorkTest {
    
    @testSetup
    static void setup() {
		// Create a Unit Of Work
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[] {
                Account.SObjectType,
                Contact.SObjectType,
                Note.SObjectType
            }
        );
        
        for(Integer indice = 0; indice < 100; indice++) {
            Account acct = new Account();
            acct.Name = 'UoW Test Name ' + indice;
            uow.registerNew(acct);
            
            for(Integer contactIndice = 0; contactIndice < 5; contactIndice++){
                Contact cont = new Contact();
                cont.lastName = 'UoW Test Last Name ' + contactIndice;
                //uow.registerRelationship(cont, Contact.AccountId, acct);
                uow.registerNew(cont, Contact.AccountId, acct);
                
                Note annotation = new Note(); 
                annotation.Title = 'UoW Test Title ' + contactIndice;
                uow.registerNew(annotation, note.ParentId, cont);
            }
        }

		// Commit the work to the database!
        uow.commitWork();
	}

    @isTest
    static void challengeComplete(){

        System.assertEquals(100, [Select Id from Account].size());
        System.assertEquals(500, [Select Id from Contact].size());
        System.assertEquals(500, [Select Id from Note].size());
    }

}