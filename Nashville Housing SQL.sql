--Standardize Date Format

select SalesDateConverted , CONVERT(Date,SaleDate)
from [Nashville Housing]

Update [Nashville Housing]
set SaleDate = CONVERT(Date , SaleDate)

Alter Table [Nashville Housing]
add SalesDateConverted Date;

Update [Nashville Housing]
set SalesDateConverted= CONVERT(Date,SaleDate)

------------------------------------------------------

-- Populate Property Address data

Select *
From [Nashville Housing]
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Nashville Housing] a
JOIN [Nashville Housing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Nashville Housing] a
JOIN [Nashville Housing] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From [Nashville Housing]
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [Nashville Housing]


ALTER TABLE [Nashville Housing]
Add PropertySplitAddress Nvarchar(255);

Update [Nashville Housing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [Nashville Housing]
Add PropertySplitCity Nvarchar(255);

Update [Nashville Housing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From [Nashville Housing]




Select OwnerAddress
From [Nashville Housing]


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [Nashville Housing]



ALTER TABLE [Nashville Housing]
Add OwnerSplitAddress Nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [Nashville Housing]
Add OwnerSplitCity Nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [Nashville Housing]
Add OwnerSplitState Nvarchar(255);

Update [Nashville Housing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [Nashville Housing]


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Nashville Housing]
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END as NewSoldAsVacant
From [Nashville Housing]


Update [Nashville Housing]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [Nashville Housing]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


Select *
From [Nashville Housing]


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From [Nashville Housing]


ALTER TABLE [Nashville Housing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate