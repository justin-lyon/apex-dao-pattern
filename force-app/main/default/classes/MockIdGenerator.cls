public with sharing class MockIdGenerator {

	public SObjectType mockType {get; private set;}

	private static Map<String, Integer> counts;
	static {
		counts = new Map<String, Integer>();
	}

	public MockIdGenerator(SObjectType type) {
		String objectName = String.valueOf(type);
		if (!counts.containsKey(objectName)) counts.put(objectName, 0);

		this.mockType = type;
	}

	public MockIdGenerator(SObject obj) {
		this(obj.getSObjectType());
	}

	// Return type of ID converts length 15 string id to length 18 id id.
	public Id getMockId() {
		return getMockId(this.mockType);
	}

	public static Id getMockId(SObject obj) {
		return getMockId(obj.getSObjectType());
	}

	public static Id getMockId(SObjectType type) {
		String objectName = String.valueOf(type);
		if (!counts.containsKey(objectName)) counts.put(objectName, 0);

		Integer currentCount = counts.get(objectName);
		counts.put(objectName, ++currentCount);
		String nextIdStub = String.valueOf(currentCount);

		return type.getDescribe().getKeyPrefix()
			+ fillId(nextIdStub)
			+ nextIdStub;
	}

	private static String fillId(String currentId) {
		return '0'.repeat(12-currentId.length());
	}
}