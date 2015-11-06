CREATE TABLE "databaseFormatVersion" (
	"databaseFormatVersion" INTEGER PRIMARY KEY
);
CREATE TABLE "files" (
	"fileID" INTEGER PRIMARY KEY,
	"fileUUID" TEXT UNIQUE,
	"typeString" TEXT,
	"name" TEXT
);
CREATE TABLE "discardedSampleUUIDs" (
	"uuid" TEXT UNIQUE
);
CREATE TABLE "workspaceLocalSettings" (
	"key" TEXT UNIQUE,
	"value" BLOB
);
CREATE TABLE "syncedSettings" (
	"key" TEXT UNIQUE,
	"value" BLOB
);
CREATE TABLE "currencies" (
    "currencyID" INTEGER PRIMARY KEY,
    "currencyCode" TEXT UNIQUE
);
CREATE TABLE "selectedCurrencies" (
    "selectedCurrencyID" INTEGER PRIMARY KEY,
    "selectedCurrencyOrder" INTEGER
);
CREATE INDEX "selectedCurrenciesSelectedCurrencyOrderIndex" ON "selectedCurrencies" ("selectedCurrencyOrder");
CREATE TABLE "customExchangeRates" (
	"firstCurrencyID" INTEGER,
	"secondCurrencyID" INTEGER,
	"rate12String" TEXT,
	"rate21String" TEXT,
	PRIMARY KEY("firstCurrencyID", "secondCurrencyID")
);
CREATE TABLE "accountGroups" (
    "accountGroupID" INTEGER PRIMARY KEY,
    "accountGroupUUID" TEXT UNIQUE,
    "sample" INTEGER,
    "name" TEXT,
    "showBalances" INTEGER,
    "includeInTotal" INTEGER,
    "accountGroupOrder" INTEGER
);
CREATE INDEX "accountGroupsAccountGroupOrderIndex" ON "accountGroups" ("accountGroupOrder");
CREATE TABLE "accounts" (
    "accountID" INTEGER PRIMARY KEY,
    "accountUUID" TEXT UNIQUE,
    "sample" INTEGER,
    "name" TEXT,
    "currencyIDOrInvalid" INTEGER,
    "note" TEXT,
    "accountGroupIDOrInvalid" INTEGER,
    "accountOrder" INTEGER
);
CREATE INDEX "accountsAccountOrderIndex" ON "accounts" ("accountOrder");
CREATE TABLE "groups" (
    "groupID" INTEGER PRIMARY KEY,
    "groupUUID" TEXT UNIQUE,
    "sample" INTEGER,
    "name" TEXT,
    "groupOrder" INTEGER
);
CREATE INDEX "groupsGroupOrderIndex" ON "groups" ("groupOrder");
CREATE TABLE "parties" (
    "partyID" INTEGER PRIMARY KEY,
    "partyUUID" TEXT UNIQUE,
    "sample" INTEGER,
    "name" TEXT
);
CREATE TABLE "tagCategories" (
    "tagCategoryID" INTEGER PRIMARY KEY,
    "tagCategoryUUID" TEXT UNIQUE,
    "sample" INTEGER,
    "name" TEXT
);
CREATE TABLE "tags" (
    "tagID" INTEGER PRIMARY KEY,
    "tagUUID" TEXT UNIQUE,
    "sample" INTEGER,
    "name" TEXT,
    "tagCategoryIDOrInvalid" INTEGER
);
CREATE TABLE "tagFavorites" (
    "tagFavoriteID" INTEGER PRIMARY KEY,
    "tagFavoriteUUID" TEXT UNIQUE,
    "tagCount" INTEGER,
    "tagFavoriteOrder" INTEGER
);
CREATE INDEX "tagFavoritesTagFavoriteOrderIndex" ON "tagFavorites" ("tagFavoriteOrder");
CREATE TABLE "tagFavoriteTags" (
    "tagFavoriteID" INTEGER,
    "tagRelaxedOrderOrMinusOne" INTEGER,
    "tagIDOrInvalid" INTEGER,
	PRIMARY KEY("tagFavoriteID", "tagRelaxedOrderOrMinusOne")
);
CREATE INDEX "tagFavoriteTagsTagIDOrInvalidIndex" ON "tagFavoriteTags" ("tagIDOrInvalid");
CREATE TABLE "records" (
    "recordID" INTEGER PRIMARY KEY,
    "recordUUID" TEXT UNIQUE,
    "sample" INTEGER,
    "recordKind" INTEGER,
    "account1IDOrInvalid" INTEGER,
    "account2IDOrInvalid" INTEGER,
    "hasForeignAmount1" INTEGER,
    "hasForeignAmount2" INTEGER,
    "currency1IDOrInvalid" INTEGER,
    "amount1" INTEGER,
    "currency2IDOrInvalid" INTEGER,
    "amount2" INTEGER,
    "currency3IDOrInvalid" INTEGER,
    "amount3" INTEGER,
    "currency4IDOrInvalid" INTEGER,
    "amount4" INTEGER,
    "localDate" INTEGER,
    "localTime" INTEGER,
    "gmtDate" INTEGER,
    "gmtTime" INTEGER,
    "tagCount" INTEGER,
    "note" TEXT,
    "fileCount" INTEGER,
    "partyIDOrInvalid" INTEGER,
    "groupIDOrInvalid" INTEGER,
    "creationTimestamp" INTEGER,
    "modificationTimestamp" INTEGER
);
CREATE INDEX "recordsRecordKindIndex" ON "records" ("recordKind");
CREATE INDEX "recordsAccount1IDOrInvalidIndex" ON "records" ("account1IDOrInvalid");
CREATE INDEX "recordsAccount2IDOrInvalidIndex" ON "records" ("account2IDOrInvalid");
CREATE INDEX "recordsLocalDateIndex" ON "records" ("localDate");
CREATE INDEX "recordsPartyIDOrInvalidIndex" ON "records" ("partyIDOrInvalid");
CREATE INDEX "recordsGroupIDOrInvalidIndex" ON "records" ("groupIDOrInvalid");
CREATE TABLE "recordTags" (
    "recordID" INTEGER,
    "tagRelaxedOrderOrMinusOne" INTEGER,
    "tagIDOrInvalid" INTEGER,
	PRIMARY KEY("recordID", "tagRelaxedOrderOrMinusOne")
);
CREATE INDEX "recordTagsTagIDOrInvalidIndex" ON "recordTags" ("tagIDOrInvalid");
CREATE TABLE "recordFiles" (
    "recordID" INTEGER,
    "fileRelaxedOrderOrMinusOne" INTEGER,
    "fileIDOrInvalid" INTEGER,
	PRIMARY KEY("recordID", "fileRelaxedOrderOrMinusOne")
);
CREATE INDEX "recordFilesFileIDOrInvalidIndex" ON "recordFiles" ("fileIDOrInvalid");
CREATE TABLE "recurringRecords" (
    "recurringRecordID" INTEGER PRIMARY KEY,
    "recurringRecordUUID" TEXT UNIQUE,
    "sample" INTEGER,
    "recordKind" INTEGER,
    "account1IDOrInvalid" INTEGER,
    "account2IDOrInvalid" INTEGER,
    "hasForeignAmount1" INTEGER,
    "hasForeignAmount2" INTEGER,
    "currency1IDOrInvalid" INTEGER,
    "amount1" INTEGER,
    "currency2IDOrInvalid" INTEGER,
    "amount2" INTEGER,
    "currency3IDOrInvalid" INTEGER,
    "amount3" INTEGER,
    "currency4IDOrInvalid" INTEGER,
    "amount4" INTEGER,
    "generationSequenceUUID" TEXT UNIQUE,
    "frequency" INTEGER,
    "firstLocalDate" INTEGER,
    "nextLocalDate" INTEGER,
    "precreateUpToLocalDate" INTEGER,
    "nonstop" INTEGER,
    "stopLocalDate" INTEGER,
    "localTime" INTEGER,
    "tagCount" INTEGER,
    "note" TEXT,
    "fileCount" INTEGER,
    "partyIDOrInvalid" INTEGER,
    "groupIDOrInvalid" INTEGER
);
CREATE TABLE "recurringRecordTags" (
    "recurringRecordID" INTEGER,
    "tagRelaxedOrderOrMinusOne" INTEGER,
    "tagIDOrInvalid" INTEGER,
    PRIMARY KEY("recurringRecordID", "tagRelaxedOrderOrMinusOne")
);
CREATE INDEX "recurringRecordTagsTagIDOrInvalidIndex" ON "recurringRecordTags" ("tagIDOrInvalid");
CREATE TABLE "recurringRecordFiles" (
    "recurringRecordID" INTEGER,
    "fileRelaxedOrderOrMinusOne" INTEGER,
    "fileIDOrInvalid" INTEGER,
    PRIMARY KEY("recurringRecordID", "fileRelaxedOrderOrMinusOne")
);
CREATE INDEX "recurringRecordFilesFileIDOrInvalidIndex" ON "recurringRecordFiles" ("fileIDOrInvalid");
CREATE TABLE "reportPresets" (
    "reportPresetID" INTEGER PRIMARY KEY,
    "reportPresetUUID" TEXT UNIQUE,
    "sample" INTEGER,
    "name" TEXT,
    "allAccountsSelected" INTEGER,
    "selectedAccountCount" INTEGER,
    "unspecifiedAccountSelected" INTEGER,
    "allCurrenciesSelected" INTEGER,
    "selectedCurrencyCount" INTEGER,
    "startDateKind" INTEGER,
    "customStartDateOrInvalid" INTEGER,
    "startTime" INTEGER,
    "endDateKind" INTEGER,
    "customEndDateOrInvalid" INTEGER,
    "endTime" INTEGER,
    "allGroupsSelected" INTEGER,
    "selectedGroupCount" INTEGER,
    "unspecifiedGroupSelected" INTEGER,
    "allPartiesSelected" INTEGER,
    "selectedPartyCount" INTEGER,
    "unspecifiedPartySelected" INTEGER,
    "allTagsSelected" INTEGER,
    "selectedTagCount" INTEGER,
    "unspecifiedTagSelected" INTEGER,
    "reportPresetOrder" INTEGER
);
CREATE TABLE "reportPresetSelectedAccounts" (
    "reportPresetID" INTEGER,
    "accountIDOrInvalid" INTEGER,
	PRIMARY KEY("reportPresetID", "accountIDOrInvalid")
);
CREATE INDEX "reportPresetSelectedAccountsAccountIDOrInvalidIndex" ON "reportPresetSelectedAccounts" ("accountIDOrInvalid");
CREATE TABLE "reportPresetSelectedCurrencies" (
    "reportPresetID" INTEGER,
    "currencyIDOrInvalid" INTEGER,
	PRIMARY KEY("reportPresetID", "currencyIDOrInvalid")
);
CREATE INDEX "reportPresetSelectedCurrenciesCurrencyIDOrInvalidIndex" ON "reportPresetSelectedCurrencies" ("currencyIDOrInvalid");
CREATE TABLE "reportPresetSelectedGroups" (
    "reportPresetID" INTEGER,
    "groupIDOrInvalid" INTEGER,
	PRIMARY KEY("reportPresetID", "groupIDOrInvalid")
);
CREATE INDEX "reportPresetSelectedGroupsGroupIDOrInvalidIndex" ON "reportPresetSelectedGroups" ("groupIDOrInvalid");
CREATE TABLE "reportPresetSelectedParties" (
    "reportPresetID" INTEGER,
    "partyIDOrInvalid" INTEGER,
	PRIMARY KEY("reportPresetID", "partyIDOrInvalid")
);
CREATE INDEX "reportPresetSelectedPartiesPartyIDOrInvalidIndex" ON "reportPresetSelectedParties" ("partyIDOrInvalid");
CREATE TABLE "reportPresetSelectedTags" (
    "reportPresetID" INTEGER,
    "tagIDOrInvalid" INTEGER,
	PRIMARY KEY("reportPresetID", "tagIDOrInvalid")
);
CREATE INDEX "reportPresetSelectedTagsTagIDOrInvalidIndex" ON "reportPresetSelectedTags" ("tagIDOrInvalid");
CREATE TABLE "retrievedExchangeRates" (
	"firstCurrencyID" INTEGER,
	"secondCurrencyID" INTEGER,
	"rate12String" TEXT,
	"rate21String" TEXT,
	"rateTimestamp" INTEGER,
	PRIMARY KEY("firstCurrencyID", "secondCurrencyID")
);
CREATE INDEX "retrievedExchangeRatesSecondCurrencyIDIndex" ON "retrievedExchangeRates" ("secondCurrencyID");
CREATE TABLE "balanceAdjustmentDeltas" (
    "recordID" INTEGER PRIMARY KEY,
    "delta" INTEGER
);
CREATE TABLE "localHistory" (
    "monthCode" INTEGER PRIMARY KEY,
    "recordCount" INTEGER
);
CREATE TABLE "recurringRecordHistory" (
    "recordID" INTEGER PRIMARY KEY,
    "recurringRecordUnsafeUUID" TEXT
);
CREATE INDEX "recurringRecordHistoryRecurringRecordUnsafeUUIDIndex" ON "recurringRecordHistory" ("recurringRecordUnsafeUUID");
CREATE TABLE "accountBalanceValidities" (
	"accountIDOrInvalid" INTEGER PRIMARY KEY,
	"validUntilDateTime" INTEGER
);
CREATE TABLE "accountBalances" (
	"accountIDOrInvalid" INTEGER,
	"currencyID" INTEGER,
	"amount" INTEGER,
	PRIMARY KEY("accountIDOrInvalid", "currencyID")
);
