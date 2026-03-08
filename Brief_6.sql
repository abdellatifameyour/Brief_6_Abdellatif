-- Ajout des contraintes dans la table FactTable

Alter table [FactTable]
add constraint fk_fact_patient foreign key ([dimPatientPK])
references [dimPatient]([dimPatientPK])

alter table [FactTable]
add constraint fk_fact_physician foreign key ([dimPhysicianPK])
references [dimPhysician]([dimPhysicianPK])

alter table [FactTable]
add constraint fk_fact_transaction foreign key ([dimTransactionPK])
references [dimTransaction]([dimTransactionPK])

alter table [FactTable]
add constraint fk_fact_payer foreign key ([dimPayerPK])
references [dimPayer]([dimPayerPK])

alter table [FactTable]
add constraint fk_fact_location foreign key ([dimLocationPK])
references [dimLocation]([dimLocationPK])

alter table [FactTable]
add constraint fk_fact_diagnosiscode foreign key ([dimDiagnosisCodePK])
references [dimDiagnosisCode]([dimDiagnosisCodePK])

alter table [FactTable]
add constraint fk_fact_cptcode foreign key ([dimCPTCodePK])
references [dimCptCode]([dimCPTCodePK])

alter table [FactTable]
add constraint fk_fact_date foreign key ([dimDatePostPK])
references [dimDate]([dimDatePostPK])


Use HealthcareDB


select column_name, data_type
from INFORMATION_SCHEMA.COLUMNS
where table_name = 'FactTable'

--Nombre des lignes + nombre total des patients
select count(*) as total_lines,
count( distinct dimPatientPK) as total_patients
from FactTable

--Vérifier s'il y a des valeurs manquantes dans la colonne dimPatientPk
select 
	sum(case when dimPatientPK is null then 1 else 0 end) as id_patients_manquants
from FactTable

--Lignes avec Montant négatif (Annulation)
select FactTablePK, GrossCharge
from FactTable
where GrossCharge <0

--Liste des GrossCharge negatifs
select f.dimPatientPK, p.PatientNumber, p.FirstName, p.LastName, count(*) as nbr_gross_negatif
from FactTable f
left join dimPatient p
on f.dimPatientPK = p.dimPatientPK
where f.GrossCharge < 0 
group by f.dimPatientPK, p.PatientNumber, p.FirstName, p.LastName

-- Affichage d'historique d'un seul patient
select f.dimPatientPK, f.CPTUnits, f.GrossCharge, f.Payment, f.Adjustment, f.AR, d.Date, t.TransactionType from
FactTable f
inner join dimDate d
on f.dimDatePostPK = d.dimDatePostPK
inner join dimTransaction t
on f.dimTransactionPK = t.dimTransactionPK
where dimPatientPK='5501322'
order by d.Date


--jointures
Use HealthcareDB
-- Informations sur Patient
select 
	distinct dimPatientPK,
	PatientNumber,
	FirstName,
	LastName,
	PatientGender,
	PatientAge,
	city,
	state
from dimPatient
where dimPatientPK = '5501268'

--localisation et dates de services
select 
	distinct f.dimPatientPK ,
	l.LocationName,
	d.Date
from FactTable f
inner join dimPatient p
on f.dimPatientPK = p.dimPatientPK
inner join dimLocation l
on f.dimLocationPK = l.dimLocationPK
inner join dimDate d
on f.dimDatePostPK = d.dimDatePostPK
where f.dimPatientPK = '5501268'
and l.LocationName = 'Angelstone Community Hospital'
order by d.Date

--informations sur les médecins et charges
select distinct p.dimPatientPK,
	p.PatientNumber,
	p.FirstName,
	p.LastName,
	p.PatientGender,
	p.PatientAge,
	p.city,
	p.state,
	m.ProviderName,
	m.ProviderSpecialty

from dimPatient p
inner join FactTable f on p.dimPatientPK = f.dimPatientPK
inner join dimPhysician m on f.dimPhysicianPK = m.dimPhysicianPK
where p.dimPatientPK = '5501268'

--codes de diagnostic et codes CPT
select distinct p.dimPatientPK,
	p.PatientNumber,
	p.FirstName,
	p.LastName,
	p.PatientGender,
	p.PatientAge,
	p.city,
	p.state,
	cpt.CptCode,
	dc.DiagnosisCode

from dimPatient p
inner join FactTable f on p.dimPatientPK = f.dimPatientPK
inner join dimCptCode cpt on f.dimCPTCodePK = cpt.dimCPTCodePK
inner join dimDiagnosisCode dc on f.dimDiagnosisCodePK = dc.dimDiagnosisCodePK
where p.dimPatientPK = '5501268' and dc.DiagnosisCode = 'S222'

--transactions, paiements et ajustements
select distinct p.dimPatientPK,
				p.PatientNumber,
				p.FirstName,
				p.LastName,
				p.PatientGender,
				p.PatientAge,
				p.city,
				p.[state],
				t.[Transaction],
				t.TransactionType
from dimPatient p 
inner join FactTable f on p.dimPatientPK = f.dimPatientPK
inner join dimTransaction t on f.dimTransactionPK = t.dimTransactionPK
where p.dimPatientPK = '5501268' and t.TransactionType in ('Payment','Adjustment')

--10 requêtes SQL 
--1
select count(*) as Nbr_lignes
from FactTable
where GrossCharge > 100

--2
select count(distinct dimPatientPK) as Patients_Uniques
from FactTable

--3
select CptGrouping, count(distinct CptCode) as Nbr_CptCode
from dimCptCode
group by CptGrouping

--4
select count(distinct f.dimPhysicianPK ) Nbr_Medecins
from FactTable f
inner join dimPayer p on f.dimPayerPK = p.dimPayerPK
where p.PayerName = 'Medicare'

--5
select count(*) from (
		select cc.CptCode , sum(f.CPTUnits) as Units
		from FactTable f
		inner join dimCptCode cc on f.dimCPTCodePK = cc.dimCPTCodePK
		group by cc.CptCode
		having sum(f.CPTUnits) > 100
	) as Total_CPTs

--6

select TOP 1 m.ProviderSpecialty, -sum(f.Payment) as Total_Payments
from FactTable f
inner join dimPhysician m on f.dimPhysicianPK = m.dimPhysicianPK
group by m.ProviderSpecialty
order by sum(f.Payment) 

--7

select distinct dc.DiagnosisCode, sum(f.CPTUnits) as nbr_units
from FactTable f
inner join dimDiagnosisCode dc on f.dimDiagnosisCodePK = dc.dimDiagnosisCodePK
where dc.DiagnosisCode like 'J%'
group by dc.DiagnosisCode
order by  sum(f.CPTUnits) desc

--8
select distinct FirstName, LastName, PatientGender, PatientAge, City,
	case
		when PatientAge < 18 then '< 18'
		when PatientAge > = 18 and PatientAge < = 65 then '18-65'
		else '> 65'
	end as "Tranche d'age"
from dimPatient 

--9
select -sum(f.Adjustment) as Adjustment
from FactTable f
inner join dimTransaction t on f.dimTransactionPK = t.dimTransactionPK
where TransactionType = 'Adjustment' and t.AdjustmentReason = 'Credentialing'


select TOP 1 l.LocationName, -sum(f.Adjustment) as Adjustment
from FactTable f
inner join dimTransaction t on f.dimTransactionPK = t.dimTransactionPK
inner join dimLocation l on f.dimLocationPK = l.dimLocationPK
where TransactionType = 'Adjustment' and t.AdjustmentReason = 'Credentialing'
group by l.LocationName
order by -sum(f.Adjustment) desc


select count(m.dimPhysicianPK) as nbr_medecins
from FactTable f
inner join dimTransaction t on f.dimTransactionPK = t.dimTransactionPK
inner join dimPhysician m on f.dimPhysicianPK = m.dimPhysicianPK
where TransactionType = 'Adjustment' and t.AdjustmentReason = 'Credentialing'






