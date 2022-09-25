SP_RENAME 'Nashville Housing Data', 'Nashville_Housing_Data'

SELECT TOP (1000) [UniqueID],
[ParcelID],
[LandUse],
[PropertyAddress],
[SaleDate],
[SalePrice],
[LegalReference],
[SoldAsVacant],
[OwnerName],
[OwnerAddress],
[Acreage],
[TaxDistrict],
[LandValue],
[BuildingValue],
[TotalValue],
[YearBuilt],
[Bedrooms],
[FullBath],
[HalfBath]
FROM dbo.Nashville_Housing_Data

--Change sale date
SELECT SaleDate, CONVERT(DATE, SaleDate)
FROM dbo.Nashville_Housing_Data

UPDATE Nashville_Housing_Data
SET SaleDate = CONVERT(DATE, SaleDate)

SELECT SaleDate 
FROM dbo.Nashville_Housing_Data

---Poperty Address data
SELECT*
FROM dbo.Nashville_Housing_Data 
WHERE PropertyAddress IS NULL;

SELECT NH.ParcelID, NH.PropertyAddress, ND.ParcelID, ND.PropertyAddress
FROM dbo.Nashville_Housing_Data NH
JOIN dbo.Nashville_Housing_Data ND 
ON NH.ParcelID = ND. ParcelID
AND NH.UniqueID <> ND.UniqueID
WHERE NH.PropertyAddress is NULL

SELECT NH.ParcelID, NH.PropertyAddress, ND.ParcelID, ND.PropertyAddress, ISNULL(NH.PropertyAddress, ND.PropertyAddress )
FROM dbo.Nashville_Housing_Data NH
JOIN dbo.Nashville_Housing_Data ND 
ON NH.ParcelID = ND. ParcelID
AND NH.UniqueID <> ND.UniqueID
WHERE NH.PropertyAddress is NULL

UPDATE NH 
SET PropertyAddress = ISNULL(NH.PropertyAddress, ND.PropertyAddress )
FROM dbo.Nashville_Housing_Data NH
JOIN dbo.Nashville_Housing_Data ND 
ON NH.ParcelID = ND.ParcelID
AND NH.UniqueID <> ND.UniqueID
WHERE NH.PropertyAddress is NULL

--Separating Address into individual Columns 

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1 ) as Adress
, SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress)) as Adress
FROM dbo.Nashville_Housing_Data

ALTER TABLE dbo.Nashville_Housing_Data
ADD SplitAddress NVARCHAR(255)

UPDATE dbo.Nashville_Housing_Data
SET SplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',' , PropertyAddress) -1 )

ALTER TABLE dbo.Nashville_Housing_Data
ADD City NVARCHAR(255)

UPDATE dbo.Nashville_Housing_Data
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress))


SELECT 
PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 1)
FROM dbo.Nashville_Housing_Data

ALTER TABLE dbo.Nashville_Housing_Data
ADD OwnerSplitAddress NVARCHAR(255)

UPDATE dbo.Nashville_Housing_Data
SET OwnerSplitAddress =PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 3)

ALTER TABLE dbo.Nashville_Housing_Data
ADD OwnerCity NVARCHAR(255)

UPDATE dbo.Nashville_Housing_Data
SET OwnerCity =PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 2)


ALTER TABLE dbo.Nashville_Housing_Data
ADD OwnerState NVARCHAR(255)

UPDATE dbo.Nashville_Housing_Data
SET OwnerState =PARSENAME(REPLACE(OwnerAddress, ',' , '.') , 1)

SELECT * FROM dbo.Nashville_Housing_Data

-- Y and N to YES and NO 'SoldAsVacant

SELECT SoldAsVacant
,CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
      WHEN SoldAsVacant= 'N' THEN 'NO'
      ELSE SoldAsVacant
      END
FROM dbo.Nashville_Housing_Data

UPDATE dbo.Nashville_Housing_Data
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
      WHEN SoldAsVacant= 'N' THEN 'NO'
      ELSE SoldAsVacant
      END

--Remove Duplicates--

WITH RownumCTE AS(
SELECT *,
      ROW_NUMBER() OVER (
          PARTITION BY ParcelID,
          PropertyAddress,
          SalePrice,
          SaleDate,
          LegalReference 
          ORDER BY UniqueID
      )row_num
FROM dbo.Nashville_Housing_Data
)
DELETE FROM RownumCTE
WHERE Row_num > 1

--Delet Unused Column

SELECT * 
FROM dbo.Nashville_Housing_Data

ALTER TABLE dbo.Nashville_Housing_Data
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress