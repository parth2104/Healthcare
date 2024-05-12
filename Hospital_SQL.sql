
--query using In with count
select* from PatientMaster
select count(distinct age) from PatientMaster
select count(age) from PatientMaster

--query using IN with count
select* from tbl_ClinicDetails
where ClinicName in ('malad west','bandra west','vashi')and countryid=1 and stateid=2
select count(distinct phoneno1)from tbl_clinicdetails
select count(phoneno1)from tbl_clinicdetails


--write the average of the grand total for clinic id 18
select avg(grandtotal) as grandtotal
from invoicemaster where clinicid=18


--Find the paid amount for doctor id 57
select paidamount ,pendingamount,patientid
from invoicemaster
where doctorid=57 and grandtotal<'40000' and grandtotal>'20000'

  
--Find the Null value in phone1 and phone2

select* from tbl_clinicdetails 
where phoneno2 is null or phoneno1 is null
order by clinicname


--WRITE QUERIES USING SELECT TOP WITH ASC/DESC.

select* from PatientMaster

select top 10 ClinicID,Gender from PatientMaster

--1.query using select top with ascending or descending.
select top 8* from PatientMaster
where gender='male' and age<=40 and age>=5
order by FristName desc ,LastName desc

--2.query using select top with asc/desc.
select top 15* from InvoiceMaster
where GrandTotal>10000 and ClinicID=15
order by PendingAmount desc

--(extra) query using top with in opertaor with asc 
select * from InvoiceMaster

select top 50* from InvoiceMaster
where ClinicID in (15,26,14)
order by PendingAmount asc


--*Join*
--1.query( WRITE A QUERY TO COUNT NUMBER OF DOCTORS IN A PARTICULAR CLINIC)
select* from tbl_ClinicDetails
select * from tbl_DoctorDetails
select* from PatientMaster

 select CD.clinicname as clinicname,count(DD.clinicid)  as NO_of_doctor from tbl_ClinicDetails CD
 left join tbl_DoctorDetails DD
 on CD.ClinicID=DD.ClinicID
 group by CD.ClinicName
  

--2.query( WRITE A QUERY TO COUNT NUMBER OF DOCTORS IN A PARTICULAR CLINIC AND NUMBER OF PATIENT IN A PARTICULAR CLINIC)
 select CD.clinicname as clinicname,count(DD.clinicid)  as NO_of_doctor,count(PM.clinicid) as NO_of_patient from tbl_ClinicDetails CD
 left join tbl_DoctorDetails DD on CD.ClinicID=DD.ClinicID
 left join PatientMaster PM on CD.ClinicID=PM.ClinicID
  group by CD.ClinicName



--3.query( WRITE A QUERY TO COLLECT THE TOTAL PAIDAMOUT COLLECTED BY EACH CLINIC )
select* from InvoiceMaster
select * from tbl_ClinicDetails

select CD.clinicname as clinicname, isnull(sum(INM.paidamount),0) as paidamount from tbl_ClinicDetails CD
left join InvoiceMaster INM
On CD.ClinicID=INM.ClinicID
group by CD.ClinicName

--3.query( WRITE A QUERY TO COLLECT THE TOTAL PAIDAMOUT,PENDINGAMOUNT,GRANDTOTAL,NUMBER OF TIMES COLLECTION MADE, COLLECTED BY EACH CLINIC )
select* from InvoiceMaster
select* from tbl_ClinicDetails

select CD.clinicname, count(INM.clinicid) as no_of_invoice,isnull(sum(INM.Grandtotal),0) as Grandtotal,isnull(sum(INM.paidamount),0) 
as paidamount,isnull(sum(INM.pendingamount),0) as pendingamount 
from tbl_ClinicDetails CD
left join InvoiceMaster INM
on CD.ClinicID=INM.ClinicID
group by CD.ClinicName



--4.QUERY(WRITE A QUERY TO FIND NO OF INVOICE,THE TOTAL PAIDAMOUNT AND PENDING AMOUNT COLLECTED BY A PARTICULAR DOCTOR )

select * from tbl_DoctorDetails
select* from InvoiceMaster

select DD.firstname+' '+DD.lastname as doctor_name, count(INM.clinicid) as no_of_invoice,isnull(sum(INM.Grandtotal),0) 
as Grandtotal,isnull(sum(INM.paidamount),0) as paidamount,isnull(sum(INM.pendingamount),0) as pendingamount 
from tbl_DoctorDetails DD
left join InvoiceMaster INM
on DD.ClinicID=INM.ClinicID
group by DD.firstname+' '+DD.lastname

--5.query	WRITE A QUERY TO DISPLAY THE CLINICNAME,WHICH TREATMENT TOOK PLACE IN THAT CLINIC,WHAT IS THE NUMBER OF TREATMENT AND WHAT IS THE PAIDAMOUNT.

select CD.clinicname as clinicname,TM.treatmentname as Tname,count(ID.TreatmentID) as no_of_treatment,isnull(sum(INM.paidamount),0) 
as paidamount
from tbl_ClinicDetails CD 
left join InvoiceMaster INM on CD.ClinicID=INM.ClinicID
left join InvoiceDetails ID on INM.InvoiceTid=ID.Invoiceid 
left join  treatmentmaster TM on ID.TreatmentID=TM.TreatmentID
group by CD.ClinicName,TM.TreatmentName

--6. WRITE A QUERY TO DISPLAY TREATMENT NAME ,NUMBER OF DOCTOR PERFORM A PARTICULAR TREATMENT,NUMBER OF CLINIC IN WHICH THAT PARTICULAR TREATMENT GOT PERFORMED.

select TM.treatmentname as treatmentname, count(ID.DoctorID) as no_of_doctor_perform_resp_treatment,
count(CD.ClinicID) as no_of_clinic_in_which_treatment_held
from TreatmentMASTER TM 
left join InvoiceDetails ID on TM.TreatmentID=ID.TreatmentID
left join InvoiceMaster INM on ID.Invoiceid=INM.InvoiceTid 
left join tbl_ClinicDetails CD on INM.ClinicID=CD.clinicid
group by TM.TreatmentName

 --7.write an SQL query to provide a comprehensive overview of each clinic's performance. 

select CD.clinicname ,count(distinct PM.patientid) as NO_of_patient,count(distinct DD.DoctorID) as no_of_doc,count(ID.treatmentid)as no_of_treatment, isnull(sum(IM.paidamount),0) as paidamount
from tbl_ClinicDetails CD 
left join PatientMaster PM on CD.ClinicID=PM.ClinicID
inner join tbl_DoctorDetails DD on CD.ClinicID=DD.ClinicID
left join InvoiceMaster IM on CD.ClinicID=IM.ClinicID 
left join InvoiceDetails ID on IM.InvoiceTid=ID.Invoiceid
left join TreatmentMASTER TM on ID.TreatmentID=TM.TreatmentID
group by CD.clinicname

 --8.WRITE QUERY TO DISPLAY ONLY THOSE PATIENTS WHO PAIDAMOUNT(SOME OR FULL NO MATTER),WE WANT NAME OF THOSE PATIENTS AND THEIR MOBILE NUMBER.
--ALSO THE NAME OF THE CLINIC IN WHICH THEY HAVE VISITED.
select PM.fristname+' '+PM.lastname as Pname,PM.mobile as mobileno,CD.clinicname as clinicname 
from PatientMaster PM 
inner join InvoiceMaster INM on PM.patientid=INM.patientid
inner join tbl_ClinicDetails CD on PM.ClinicID=CD.ClinicID
group by PM.fristname+' '+PM.lastname, PM.mobile ,CD.clinicname

 --9.WRITE QUERY TO DISPLAY ONLY THOSE PATIENTS WHO PAIDAMOUNT(SOME OR FULL NO MATTER),WE WANT NAME OF THOSE PATIENTS AND THEIR MOBILE NUMBER.
--ALSO THE NAME OF THE CLINIC IN WHICH THEY HAVE VISITED,SHOE PAIDAMOUNT AND GRANDTOTAL.

select PM.fristname+' '+PM.lastname as Pname,PM.mobile as mobileno,CD.clinicname as clinicname,isnull(sum(INM.grandtotal),0)  as grandtotal,
isnull(sum(INM.paidamount),0) as paidamount
from PatientMaster PM 
inner join InvoiceMaster INM on PM.patientid=INM.patientid
inner join tbl_ClinicDetails CD on PM.ClinicID=CD.ClinicID
group by PM.fristname+' '+PM.lastname, PM.mobile ,CD.clinicname

