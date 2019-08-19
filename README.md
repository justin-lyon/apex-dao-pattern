# apex-dao-pattern

Salesforce APEX is unique to other OO Languages in that we can use SOQL/SOSL or DML in-line anywhere within the code base. Developers can quickly and immediately author a query, or insert a collection of records in the class they are currently working.

With great power comes great catastrophe.

With some discipline, data access in Apex can be streamlined to a single pattern. This pattern allows for the collocation of all queries and dml statements in Data Access Modules, by SObject. Each module is four Apex Classes. The classes are named for the SObject and their role in the module. Each module extends a core DmlInterface Module.

# Contents

 1. [The DML Module](#the-dml-module)
 1. [The Data Access Module Roles](#the-data-access-module-roles)

## The DML Module

Nearly all SObjects support DML operations of INSERT, UPDATE, UPSERT, and DELETE. In support of this, the DML Module describes an SObject generic method for each of these DML statements. The DML Module is a closed interface, extended by your SObject DAI.

### DmlInterface

DmlInterface describes the four DML methods available to SObjects.

Extended by your DAI Interface.
```java
public interface DmlInterface {
	void insertRecords(List<SObject> newRecords);
	void updateRecords(List<SObject> records);
	void upsertRecords(List<SObject> records);
	void deleteRecords(List<SObject> records);
}
```

### DmlBase

DmlBase is the runtime implementation of the Dml methods.

Extended by your DA class.
```java
public abstract class DmlBase implements DmlInterface {

	public void insertRecords(List<SObject> newRecords) {
		insert newRecords;
	}

	public void updateRecords(List<SObject> records) {
		update records;
	}

	public void upsertRecords(List<SObject> records) {
		upsert records;
	}

	public void deleteRecords(List<SObject> records) {
		delete records;
	}
}
```

### DmlBaseMock

DmlBaseMock is the mock implementation of the Dml Methods. This class is a complete mock of the database DML implementation. For example, an inserted record should be given an ID or an updated record must have an ID. Data is stateful within the Mock and passed by reference to the associated DAMock.

Extended by your DAMock class.
```java
public abstract class DmlBaseMock implements DmlInterface {
	protected Map<Id, SObject> Records;
	public MockSObjectBuilder Builder;

	private static final String ID_FIELD = 'Id';

	public DmlBaseMock(Map<Id, SObject> records, Schema.SObjectType objectType) {
		this.Records = records;
		this.builder = new MockSObjectBuilder(objectType);
	}

	public List<SObject> getRecords() {
		return this.Records.values();
	}

	public void insertRecords(List<SObject> newRecords) {
		for (SObject record : newRecords) {
			if (record.get(ID_FIELD) != null) {
				throw new DmlException('Cannot insert a record with an ID.');
			}
			Id recordId = builder.getMockId();
			record.put(ID_FIELD, recordId);
			this.Records.put((Id)recordId, record);
		}
	}

	public void updateRecords(List<SObject> records) {
		for (SObject record : records) {
			if (record.get(ID_FIELD) == null) {
				throw new DmlException('Records to update must have a record Id.');
			}
			this.Records.put((Id)record.get(ID_FIELD), record);
		}
	}

	public void upsertRecords(List<SObject> records) {
		for (SObject record : records) {
			if (record.get(ID_FIELD) == null) {
				Id recordId = builder.getMockId();
				record.put(ID_FIELD, recordId);
			}
			this.Records.put((Id)record.get(ID_FIELD), record);
		}
	}

	public void deleteRecords(List<SObject> records) {
		for (SObject record : records) {
			if (record.get(ID_FIELD) == null) {
				throw new DmlException('Records to delete must have a record Id.');
			}
			this.Records.remove((Id)record.get(ID_FIELD));
		}
	}
}
```

### DmlBaseTest

Test class for the DmlBase class.
```java
@isTest
private class DmlBaseTest {
  // Test Methods for the DMLBase implementation.
}
```

## The Data Access Module Roles:

In following this pattern, developers will create/edit/maintain the four following classes per SObject for each Data Access Module.

### Data Access Interface (DAI)

The Interface which defines the method signatures that the DA and DAMock implementations are responsible for.

AccountDAI describes the queries that must be implemented by AccountDA and AccountDAMock.
```java
public interface AccountDAI extends DmlInterface {
	List<Account> queryFiveRecentAccounts();
}
```

### Data Accessor (DA)

The runtime implementation for Data Access. Methods are implemented per the DAI.

AccountDA uses a SOQL Query to get recent accounts from the Salesforce Database.
```java
public inherited sharing class AccountDA extends DmlBase implements AccountDAI {
  public List<Account> queryFiveRecentAccounts() {
    return [
			SELECT Id,
				Name
			FROM Account
			ORDER BY CreatedDate ASC
			LIMIT 5];
  }
}
```

### Data Accessor Mock (DAMock)

A Mock Implementation for Data Access. Methods are implemented per the DAI. Class is annotated `@isTest`.

AccountDAMock returns fake account data instead of hitting the Database.
```java
@isTest
public inherited sharing class AccountDAMock extends DmlBaseMock implements AccountDAI {
  public List<Account> queryFiveRecentAccounts() {
    List<Account> foundAccounts = new List<Account>();
    foundAccounts.add(new Account(Name = 'Mock Account'));
    return foundAccounts;
  }
}
```

### Data Accessor Test (DATest)

A Test for the runtime Data Accessor (DA).

```java
@isTest
private class AccountDATest {
  // ...Unit Tests for AccountDA
}
```
