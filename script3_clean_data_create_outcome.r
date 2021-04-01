########################################################################################################
##### R script for aggregation of ICD10 codes, cleaning data and definition of other variables.
##### Author: Arjen Cupido
##### Last update: 2021/04/01
##### EMAIL: arjen.cupido@gmail.com
########################################################################################################

###libraries

library(dplyr)
library(data.table)
library(stringr)

#############
### DATA
message("load data")
#read file
d <- data.table(read.delim("<USER>/UKB_files/2021/ICD_outcome.tab", sep = '\t', header=T))
columnnames <- colnames(d)
setDT(d)
backup <- d


# Outcome list from CALIBER
outcomes <-  read.csv("<USER>/UKB_files/2021/CALIBER/dictionary.csv")
fields <- read.csv("<USER>/UKB_scripts/20210129_NEW/fields.csv")

############
# Define which field is what type of field. I have defined the following: ICD10, ICD9, Procedures, Death registries, Self report, Principal components

ICD10 <- grep("41270", colnames(d)) 
ICD10date <-grep("41280", colnames(d), value = T) 

ICD9 <- grep("41271", colnames(d)) 
ICD9date <-grep("41281", colnames(d), value = T) 

proc <- grep("41272", colnames(d))
procdate <- grep("41282", colnames(d))

death_main <- grep("f.40001", colnames(d))
death_sec <- grep("f.40002", colnames(d))
medication <- grep("f.20003.0", colnames(d))

# Final aggregate
PC <- grep("f.22009", colnames(d)) # 109-148

self_rep <- grep("f.20002", colnames(d)) # 4 - 105

death <- c(death_main, death_sec)

################################################
###### Define clinical outcome paramaters ######
################################################

message("Construct personally defined outcomes...")
message("CHD") 

# CHD
d$CHD10intermediate <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("I21|I22|I23|I241|I248|I249|I251|I252|I253|I255|I256|I258|I259", r, value =T)))))

d$CHD10hard <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("I21|I22|I23|I241|I248|I249|I252", r, value =T)))))

d$CHD10soft <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("I20|I21|I22|I23|I24|I251|I252|I253|I255|I256|I258|I259", r, value =T)))))

d$CDH9intermediate <- as.integer(apply(d[,..ICD9], 1, function(r) any(r %in% c(grep("^410|^411|^412|^4140|^4148|^4149", r, value =T)))))

d$CHD9hard <- as.integer(apply(d[,..ICD9], 1, function(r) any(r %in% c(grep("^410|^411|^412", r, value =T)))))

d$CHD9soft <- as.integer(apply(d[,..ICD9], 1, function(r) any(r %in% c(grep("^410|^411|^412|^413|^4140|^4148|^4149", r, value =T)))))

d$CHDself <-  as.integer(apply(d[,..self_rep], 1, function(r) any(r %in% c(grep("^1075", r, value =T))))) 

d$CHDselfsoft <-  as.integer(apply(d[,..self_rep], 1, function(r) any(r %in% c(grep("^1074|^1075", r, value =T))))) 

d$CHDintermediatefull <- ifelse(d$CHD10intermediate == 1 | d$CHD9intermediate ==1 |d$CHDself == 1, 1, 0)

d$CHDhardfull <- ifelse(d$CHD10hard == 1 | d$CHD9hard ==1 |d$CHDself == 1, 1, 0)

d$CHDsoftfull <- ifelse(d$CHD10soft == 1 | d$CHD9soft ==1 |d$CHDselfsoft == 1, 1, 0)

message("CHD death")

# CHD death
d$CHD_DEATH <- as.integer(apply(d[,..death], 1, function(r) any(r %in% c(grep("I21|I22|I23|I24|I251|I252|I253|I255|I256|I258|I259", r, value =T)))))

message("Revascularization")

# Revascularization
d$PTCA_CABG <- as.integer(apply(d[,..proc], 1, function(r) any(r %in% c(grep("K40|K41|K42|K43|K44|K45|K46", r, value =T)))))

message("PTA and PAD")
# PTA
d$PTA <- as.integer(apply(d[,..proc], 1, function(r) any(r %in% c(grep("K49", r, value =T)))))

# Other revascularizations
d$otherrevasc <- as.integer(apply(d[,..proc], 1, function(r) any(r %in% c(grep("K501|K502|K504", r, value =T)))))

# PTA stents
d$ptastent <- as.integer(apply(d[,..proc], 1, function(r) any(r %in% c(grep("K75", r, value =T)))))

# Peripheral Artery Disease
d$PAD10 <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("I70|I74|I378|I379", r, value =T)))))
d$PAD_DEATH <-  as.integer(apply(d[,..death], 1, function(r) any(r %in% c(grep("I70|I74|I378|I379", r, value =T)))))
d$PAD9 <-  as.integer(apply(d[,..ICD9], 1, function(r) any(r %in% c(grep("^440|^444|^4438|4439", r, value =T)))))
d$PADself <-  as.integer(apply(d[,..self_rep], 1, function(r) any(r %in% c(grep("1067", r, value =T))))) 

d$PADfull <- ifelse(d$PAD10 == 1 | d$PAD9 ==1 |d$PADself == 1 | d$PAD_DEATH == 1, 1, 0)

# Coronary artery disease definition: CHD death, revasc, MI  

# Intermediate
d$AllCADintermediate <- ifelse(d$CHD_DEATH ==1 | d$PTCA_CABG == 1 | d$PTA == 1 | d$otherrevasc == 1 | d$ptastent ==1 | d$CHDintermediatefull == 1, 1,0)

d$AllCADintermediate[is.na(d$AllCADintermediate)] <- 0


# Hard definition
d$AllCADhard <- ifelse(d$CHD_DEATH ==1 | d$PTCA_CABG == 1 | d$PTA == 1 | d$otherrevasc == 1 | d$ptastent ==1 | d$CHDhardfull == 1, 1,0)

d$AllCADhard[is.na(d$AllCADhard)] <- 0

# Soft definition
d$AllCADsoft <- ifelse(d$CHD_DEATH ==1 | d$PTCA_CABG == 1 | d$PTA == 1 | d$otherrevasc == 1 | d$ptastent ==1 | d$CHDsoftfull == 1 | d$PTA == 1, 1,0)

d$AllCADsoft[is.na(d$AllCADsoft)] <- 0

# Composite revasc
d$HeartProcedure <- ifelse(d$PTCA_CABG == 1 | d$PTA == 1 | d$otherrevasc == 1 | d$ptastent ==1, 1,0)

d$HeartProcedure[is.na(d$HeartProcedure)] <- 0

# Ischemic stroke according to UKB definition
message('Ischemic stroke')
d$strokeischemic10 <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("I63|I64", r, value =T)))))
d$strokeischemic_DEATH <-  as.integer(apply(d[,..death], 1, function(r) any(r %in% c(grep("I63|I64", r, value =T)))))
d$strokeischemic9 <-  as.integer(apply(d[,..ICD9], 1, function(r) any(r %in% c(grep("^434|^436", r, value =T)))))
d$strokeischemicself <-  as.integer(apply(d[,..self_rep], 1, function(r) any(r %in% c(grep("^1583", r, value =T))))) 

d$strokeischemicfull <- ifelse(d$strokeischemic10 == 1 | d$strokeischemic9 ==1 |d$strokeischemicself == 1 | d$strokeischemic_DEATH == 1, 1, 0)


message("go on with HF")
# Heart Failure
d$HF <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("I50|I110|I130|I132", r, value =T))))) + 
  as.integer(apply(d[,..death], 1, function(r) any(r %in% c(grep("I50|I110|I130|I132", r, value =T)))))+
  as.integer(apply(d[,..ICD9], 1, function(r) any(r %in% c(grep("^428", r, value =T))))) +
  as.integer(apply(d[,..self_rep], 1, function(r) any(r %in% c(grep("1076", r, value =T))))) 

d$HF <- ifelse(d$HF <= 1, d$HF, 1)

message("CKD")
# Chronic kidney disease
d$CKD <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("N18|I12|I13", r, value =T)
)))) + 
  as.integer(apply(d[,..death], 1, function(r) any(r %in% c(grep("N18|I12|I13", r, value =T)))))+
  as.integer(apply(d[,..ICD9], 1, function(r) any(r %in% c(grep("^585", r, value =T))))) +
  as.integer(apply(d[,..self_rep], 1, function(r) any(r %in% c(grep(1192|1193|1194, r, value=T))))) 

d$CKD <- ifelse(d$CKD <= 1, d$CKD, 1)

# Aortic stenosis
d$AOST <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("I350", r, value=T))))) + 
  as.integer(apply(d[,..death], 1, function(r) any(r %in% c(grep("I350", r, value=T)))))+
  as.integer(apply(d[,..self_rep], 1, function(r) any(r %in% c(grep("1490", r, value=T))))) 

d$AOST <- ifelse(d$AOST <= 1, d$AOST, 1) # recode all patients with more than 1 to 1

# Aortic stenosis
d$AOST_WIDE <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("I350|I352", r, value=T))))) + 
  as.integer(apply(d[,..death], 1, function(r) any(r %in% c(grep("I350|I352", r, value=T)))))+
  as.integer(apply(d[,..self_rep], 1, function(r) any(r %in% c(grep("1490", r, value=T))))) 

d$AOST_WIDE <- ifelse(d$AOST_WIDE <= 1, d$AOST_WIDE, 1) # recode all patients with more than 1 to 1

# Atrial Fibrillation
d$AF <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("I48", r, value =T)
)))) + 
  as.integer(apply(d[,..death], 1, function(r) any(r %in% c(grep("I48", r, value =T)
  ))))+
  as.integer(apply(d[,..ICD9], 1, function(r) any(r %in% c(grep("^4273", r, value =T) 
  )))) +
  as.integer(apply(d[,..self_rep], 1, function(r) any(r %in% c(grep("1471|1483", r, value=T)
  )))) 

d$AF <- ifelse(d$AF <= 1, d$AF, 1) # recode all patients with more than 1 to 1

# VTE
d$VTE <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("I26|I801|I802|I81|I820", r, value =T)
)))) + 
  as.integer(apply(d[,..death], 1, function(r) any(r %in% c(grep("I26|I801|I802|I81|I820", r, value =T)
  ))))+
  as.integer(apply(d[,..ICD9], 1, function(r) any(r %in% c(grep("^4151|^4511|^452|^4530|^4534|^4539", r, value =T) 
  )))) +
  as.integer(apply(d[,..self_rep], 1, function(r) any(r %in% c(grep("1068|1093|1094", r, value=T)
  )))) 

d$VTE <- ifelse(d$VTE <= 1, d$VTE, 1) # recode all patients with more than 1 to 1

# Pulmonary embolism & thombosis

d$pe_thm <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("I260|I269|I801|I802|I803|I808", r, value =T))))) + 
  as.integer(apply(d[,..ICD9], 1, function(r) any(r %in% c(grep("^4534|^4511|^453", r, value =T))))) 

d$pe_thm<- ifelse(d$pe_thm <= 1, d$pe_thm, 1)

# Aortic Aneurysm and dissection
d$AAD <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("I71", r, value =T)
)))) + 
  as.integer(apply(d[,..death], 1, function(r) any(r %in% c(grep("I71", r, value =T)
  ))))+
  as.integer(apply(d[,..ICD9], 1, function(r) any(r %in% c(grep("^441", r, value =T) 
  )))) +
  as.integer(apply(d[,..self_rep], 1, function(r) any(r %in% c(grep("1492|1591|1592", r, value=T))))) 

d$AAD <- ifelse(d$AAD <= 1, d$AAD, 1) # recode all patients with more than 1 to 1


message("Macular Degeneration")
d$MacDeg <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("H353", r, value =T)
)))) + 
  as.integer(apply(d[,..ICD9], 1, function(r) any(r %in% c(grep("^3625", r, value =T) 
  )))) +
  as.integer(apply(d[,..self_rep], 1, function(r) any(r %in% c(grep("1528", r, value=T))))) 

d$MacDeg <- ifelse(d$MacDeg <= 1, d$MacDeg, 1) # recode all patients with more than 1 to 1

# Infections. See txt file with outcomes for link to article.
message("Infections")
# Viral infections
d$VI <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("A08|A60|A80|A81|A82|A83|A84|A85|A86|A87|A88|A89|A92|A93|A94|A95|A96|A97|A88|A99|B00|B01|B02|B03|B04|B05|B06|B07|B08|B09|B15|B16|B17|B18|B19|B20|B21|B22|B23|B24|B25|B26|B27|B28|B29|B30|B31|B32|B33|B34|B941|B942|B97", r, value=T))))) +
  as.integer(apply(d[,..death], 1, function(r) any(r %in% c(grep("A08|A60|A80|A81|A82|A83|A84|A85|A86|A87|A88|A89|A92|A93|A94|A95|A96|A97|A88|A99|B00|B01|B02|B03|B04|B05|B06|B07|B08|B09|B15|B16|B17|B18|B19|B20|B21|B22|B23|B24|B25|B26|B27|B28|B29|B30|B31|B32|B33|B34|B941|B942|B97", r, value=T)))))

d$VI <- ifelse(d$VI <= 1, d$VI, 1) # recode all patients with more than 1 to 1

# UWI
d$UTI <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("N390|O23|O86", r, value=T )))))+
  as.integer(apply(d[,..death], 1, function(r) any(r %in% c(grep("N390|O23|O86", r, value=T ))))) 

d$UWI <- ifelse(d$UWI <= 1, d$UWI, 1) # recode all patients with more than 1 to 1    

# Skin
d$SI <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("L00|L01|L02|L03|L04|L05|L06|L07|L08", r, value=T))))) +
  as.integer(apply(d[,..death], 1, function(r) any(r %in% c(grep("L00|L01|L02|L03|L04|L05|L06|L07|L08", r, value=T)))))
d$SI <- ifelse(d$SI <= 1, d$SI, 1) # recode all patients with more than 1 to 1
# Sepsis
d$SPS <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("A021|A227|A40|A41|B377|O85|R651|R527", r, value=T))))) +
  as.integer(apply(d[,..death], 1, function(r) any(r %in% c(grep("A021|A227|A40|A41|B377|O85|R651|R527", r, value=T)))))

d$SPS <- ifelse(d$SPS <= 1, d$SPS, 1) # recode all patients with more than 1 to 1    
message("Pneumonia")    
# Pneumonia
d$PNA <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c( grep("B012|J14|J12|J16|J15|J17|J18|J851", r, value=T ))))) +
  as.integer(apply(d[,..death], 1, function(r) any(r %in% c(grep("B012|J14|J12|J16|J15|J17|J18|J851", r, value=T )))))

d$PNA <- ifelse(d$PNA <= 1, d$PNA, 1) # recode all patients with more than 1 to 1

# Gastroenteritis
d$GE <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("A0", r, value =T))))) +
  as.integer(apply(d[,..death], 1, function(r) any(r %in% c(grep("A0", r, value=T )))))

d$GE <- ifelse(d$GE <= 1, d$GE, 1) # recode all patients with more than 1 to 1  

# Fungal infections
d$FI <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("B4|B34|B35|B36|B37|B38|B39", r, value =T))))) +
  as.integer(apply(d[,..death], 1, function(r) any(r %in% c(grep("B4|B34|B35|B36|B37|B38|B39", r, value =T)))))

d$FI <- ifelse(d$FI <= 1, d$FI, 1) # recode all patients with more than 1 to 1

# Bacterial infections
d$BI <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("A3|A4|A7|A00|A01|A02|A03|A04|A05|A15|A16|A17|A18|A19,A20|A21|A22|A23|A24|A25|A26|A27|A28|A51|A52|A53|A54|A56|A65|A66|A67|A68|A69|B90|B95|B96|B98", r, value =T))))) +
  as.integer(apply(d[,..death], 1, function(r) any(r %in% c(grep("A3|A4|A7|A00|A01|A02|A03|A04|A05|A15|A16|A17|A18|A19,A20|A21|A22|A23|A24|A25|A26|A27|A28|A51|A52|A53|A54|A56|A65|A66|A67|A68|A69|B90|B95|B96|B98", r, value =T)))))
d$BI <- ifelse(d$BI <= 1, d$BI, 1) # recode all patients with more than 1 to 1  


d$nonalcoholicfattyliver <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep("K760", r, value =T)
)))) 


d$statin <- as.integer(apply(d[,..medication], 1, function(r) any(r %in% c(grep("1140861958|1140888594|1140888648|1141146234|1141192410", r, value =T)))))
d$ezetimibe <- as.integer(apply(d[,..medication], 1, function(r) any(r %in% c(grep("1141192736|1141192740", r, value =T)))))

# Save checkpoint in case something goes wrong after this. 
save(d,file= "<USER>/UKB_files/2021/checkpoint1.rda")


########################
# Definition according to CALIBER
outcomes$VariableName <- gsub(" ", "", outcomes$phenotype)

message("Construct CALIBER defined outcomes...")

for(i in 1:nrow(outcomes)){
  NAME <- outcomes$VariableName[i]
  message(NAME)
  x <- read.csv(file = paste0("<USER>/UKB_files/2021/CALIBER/secondary_care/", outcomes$ICD[i]))
  y <- paste(x$ICD10code, collapse = "|")
  y <- str_remove_all(y, "[.]")
  d[[paste0(NAME)]] <- as.integer(apply(d[,..ICD10], 1, function(r) any(r %in% c(grep(y, r, value =T))))) +
    as.integer(apply(d[,..death], 1, function(r) any(r %in% c(grep(y, r, value =T))))) +
    
    if(outcomes$OPCS[i] != ""){
      xx <- read.csv(file = paste0("<USER>/UKB_files/2021/CALIBER/secondary_care/", outcomes$OPCS[i]))
      yy <- paste(xx$OPCS4code, collapse = "|")
      yy <- str_remove_all(yy, "[.]")
      as.integer(apply(d[,..proc], 1, function(r) any(r %in% c(grep(yy, r, value =T)))))
    } else (0)
  
  d[[paste0(NAME)]] <- ifelse(d[[paste0(NAME)]] <= 1, d[[paste0(NAME)]], 1)    
  
}




message("Extract dates for MI, PTCA_CABG and PAD") 
### MI ICD10  
f<- subset(d, CHD10hard ==1)

datelist <- list()
for(i in 1:nrow(f)){
  
  # Select row
  x <- f[i,]
  ID <- x$f.eid
  # Identify columns in which diagnosis is
  diagnosiscolumn <- c(apply(x[,..ICD10], 1, function(r) which(r %in% grep(pattern = "I21|I22|I23|I241|I248|I249|I252", r, value = T))))
  
  # Identify corresponding date columns
  datecolumn <- ICD10date[diagnosiscolumn]
  
  # Extract multiple of dates
  datesframe <- subset(x, select = datecolumn)
  
  # Mutate to date columns
  datesframe <- mutate_all(datesframe[1,], .funs = as.Date)
  
  # Select first occurrence 
  r <- c(apply(datesframe, 1, function(r) min(r)))
  # Append to list  
  
  colnames(datesframe) <- as.character(1:ncol(datesframe))
  
  datelist[[i]] <- data.frame("f.eid" = x$f.eid, "CHD10hard_first" =  r, datesframe)
  
}

# Unlist
dateresults <- do.call(bind_rows, datelist)

# Rename
colnames(dateresults) <- gsub("X", "CHD10hard_date", colnames(dateresults))
# dateresults
# Left_join to dataset
d<- left_join(d, dateresults, by = "f.eid")

message("MI ICD9")
### MI ICD9   
f<- subset(d, d$CHD9hard ==1)

datelist <- list()
for(i in 1:nrow(f)){
  
  # Select row
  x <- f[i,]
  ID <- x$f.eid
  # Identify columns in which diagnosis is
  diagnosiscolumn <- c(apply(x[,..ICD9], 1, function(r) which(r %in% grep(pattern = "^410|^411|^412", r, value = T))))
  
  # Identify corresponding date columns
  datecolumn <- ICD9date[diagnosiscolumn]
  
  # Extract multiple of dates
  datesframe <- subset(x, select = datecolumn)
  
  # Mutate to date columns
  datesframe <- mutate_all(datesframe[1,], .funs = as.Date)
  
  # Select first occurrence 
  r <- c(apply(datesframe, 1, function(r) min(r)))
  # Append to list  
  
  colnames(datesframe) <- as.character(1:ncol(datesframe))
  
  datelist[[i]] <- data.frame("f.eid" = x$f.eid, "CHD9hard_first" =  r, datesframe)
  
}

# Unlist
dateresults <- do.call(bind_rows, datelist)

# Rename
colnames(dateresults) <- gsub("X", "CHD9harddate", colnames(dateresults))
# Left_join to dataset
d <- left_join(d, dateresults, by = "f.eid") 

#####################
f<- subset(d, CHD10intermediate ==1)

datelist <- list()
for(i in 1:nrow(f)){
  
  # Select row
  x <- f[i,]
  ID <- x$f.eid
  # Identify columns in which diagnosis is
  diagnosiscolumn <- c(apply(x[,..ICD10], 1, function(r) which(r %in% grep(pattern = "I21|I22|I23|I241|I248|I249|I251|I252|I253|I255|I256|I258|I259", r, value = T))))
  
  # Identify corresponding date columns
  datecolumn <- ICD10date[diagnosiscolumn]
  
  # Extract multiple of dates
  datesframe <- subset(x, select = datecolumn)
  
  # Mutate to date columns
  datesframe <- mutate_all(datesframe[1,], .funs = as.Date)
  
  # Select first occurrence 
  r <- c(apply(datesframe, 1, function(r) min(r)))
  # Append to list  
  
  colnames(datesframe) <- as.character(1:ncol(datesframe))
  
  datelist[[i]] <- data.frame("f.eid" = x$f.eid, "CHD10_first" =  r, datesframe)
  
}

# Unlist
dateresults <- do.call(bind_rows, datelist)

# Rename
colnames(dateresults) <- gsub("X", "CHD10date", colnames(dateresults))
# dateresults
# Left_join to dataset
d<- left_join(d, dateresults, by = "f.eid")

message("MI ICD9")
### MI ICD9   
f<- subset(d, d$CHD9intermediate ==1)

datelist <- list()
for(i in 1:nrow(f)){
  
  # Select row
  x <- f[i,]
  ID <- x$f.eid
  # Identify columns in which diagnosis is
  diagnosiscolumn <- c(apply(x[,..ICD9], 1, function(r) which(r %in% grep(pattern = "^410|^411|^412|^4140|^4148|^4149", r, value = T))))
  
  # Identify corresponding date columns
  datecolumn <- ICD9date[diagnosiscolumn]
  
  # Extract multiple of dates
  datesframe <- subset(x, select = datecolumn)
  
  # Mutate to date columns
  datesframe <- mutate_all(datesframe[1,], .funs = as.Date)
  
  # Select first occurrence 
  r <- c(apply(datesframe, 1, function(r) min(r)))
  # Append to list  
  
  colnames(datesframe) <- as.character(1:ncol(datesframe))
  
  datelist[[i]] <- data.frame("f.eid" = x$f.eid, "CHD9_first" =  r, datesframe)
  
}

# Unlist
dateresults <- do.call(bind_rows, datelist)

# Rename
colnames(dateresults) <- gsub("X", "CHD9_date", colnames(dateresults))
# Left_join to dataset
d <- left_join(d, dateresults, by = "f.eid") 




message("Procedures")
#######  
### PTCA_CABG proc  
f<- subset(d, d$HeartProcedure ==1)

datelist <- list()
for(i in 1:nrow(f)){
  
  # Select row
  x <- f[i,]
  ID <- x$f.eid
  # Identify columns in which diagnosis is
  diagnosiscolumn <- c(apply(x[,..proc], 1, function(r) which(r %in% grep(pattern = "K40|K41|K42|K43|K44|K45|K46|K49|K501|K502|K504|K75", r, value = T))))
  
  # Identify corresponding date columns
  datecolumn <- procdate[diagnosiscolumn]
  
  # Extract multiple of dates
  datesframe <- subset(x, select = datecolumn)
  
  # Mutate to date columns
  datesframe <- mutate_all(datesframe[1,], .funs = as.Date)
  
  # Select first occurrence 
  r <- c(apply(datesframe, 1, function(r) min(r)))
  # Append to list  
  
  colnames(datesframe) <- as.character(1:ncol(datesframe))
  
  datelist[[i]] <- data.frame("f.eid" = x$f.eid, "HeartProcedure_first" =  r, datesframe)
  
}

# Unlist
dateresults <- do.call(bind_rows, datelist)

# Rename
colnames(dateresults) <- gsub("X", "HeartProcedure_date", colnames(dateresults))
# Left_join to dataset
d<-  left_join(d, dateresults, by = "f.eid")


message("wrapping up....")
save(d, file="<USER>/UKB_files/checkpoint2.rda")
#########################


for(i in 1:nrow(fields)){
  replacementcode <- fields$code[i]
  replacementtext <- fields$titlemerge[i]
  message(paste0(replacementcode)," will become ", paste0(replacementtext))
  colnames(d) <- gsub(paste0(replacementcode), paste0(replacementtext), colnames(d), fixed=T)
}           

############################

d$SEX <- as.factor(d$Sex.0.0) %>% factor(labels = c("female", "male")) # Based on field 31, data-coding 9. http://biobank.ctsu.ox.ac.uk/crystal/field.cgi?id=31

# Define age

d$CURRENTAGE <- 2021 - d$YearOfBirth.0.0
d$YEAR_VISIT <- as.numeric(substring(d$DateOfAttendingAssessmentCentre.0.0, first=1, last=4)) 
d$AGEVISIT <- d$YEAR_VISIT - d$YearOfBirth.0.0

message("Define other variables..")
# Define Cholesterol medication use for all patients. There are two variables. the CHOLBPDM is for male participants. The CHOLBPDMHOR is for female participants. based on a Showcase variable for LLT. 

d$LLT <- ifelse((d$MedicationForCholesterolBloodPressureOrDiabetes.0.0 == 1 | d$MedicationForCholesterolBloodPressureDiabetesOrTakeExogenousHormones.0.0 == 1 |d$MedicationForCholesterolBloodPressureOrDiabetes.0.1 == 1 | 
                   d$MedicationForCholesterolBloodPressureDiabetesOrTakeExogenousHormones.0.1 == 1 | d$MedicationForCholesterolBloodPressureOrDiabetes.0.2 == 1 | d$MedicationForCholesterolBloodPressureDiabetesOrTakeExogenousHormones.0.2 == 1), 1,0)

d$LLT[is.na(d$LLT)]<-0

# Define BP medication use

d$HTT <- ifelse((d$MedicationForCholesterolBloodPressureOrDiabetes.0.0 == 2 | d$MedicationForCholesterolBloodPressureDiabetesOrTakeExogenousHormones.0.0 == 2 |d$MedicationForCholesterolBloodPressureOrDiabetes.0.1 == 2 | 
                   d$MedicationForCholesterolBloodPressureDiabetesOrTakeExogenousHormones.0.1 == 2 | d$MedicationForCholesterolBloodPressureOrDiabetes.0.2 == 2 | d$MedicationForCholesterolBloodPressureDiabetesOrTakeExogenousHormones.0.2 == 2), 1,0)

d$HTT[is.na(d$HTT)]<-0

# define insulin therapy use

d$INSULIN <- ifelse((d$MedicationForCholesterolBloodPressureOrDiabetes.0.0 == 3 | d$MedicationForCholesterolBloodPressureDiabetesOrTakeExogenousHormones.0.0 == 3 |d$MedicationForCholesterolBloodPressureOrDiabetes.0.1 == 3 | 
                       d$MedicationForCholesterolBloodPressureDiabetesOrTakeExogenousHormones.0.1 == 3 | d$MedicationForCholesterolBloodPressureOrDiabetes.0.2 == 3 | d$MedicationForCholesterolBloodPressureDiabetesOrTakeExogenousHormones.0.2 == 3), 1,0)

d$INSULIN[is.na(d$INSULIN)]<-0

# Define corrected LDL based on LLT. (see PRS articles for explanation (trinder/talmud?))

d$LDLC_LLT_CORRECTED <- ifelse(d$LLT==1, d$LdlDirect.0.0*1.43, d$LdlDirect.0.0)

d$LDLC_WO_LLT <- ifelse(d$LLT !=1, d$LdlDirect.0.0, NA) # Only keeps the LDL-C for all participants without LLT
d$APOB_WO_LLT <- ifelse(d$LLT !=1, d$ApolipoproteinB.0.0, NA) # Only keeps the LDL-C for all participants without LLT
# Define HTT category

d$SBP_WO_HTT <- ifelse(d$HTT !=1, d$SystolicBloodPressureAutomatedReading.0.0, NA) # Only keeps the SBP for all participants without HTT


# Define cardiovascular disease

d$CVD <- ifelse(d$AllCADintermediate == 1 | d$strokeischemicfull == 1, 1, 0)

d$CVD[is.na(d$CVD)] <- 0
# Define diabetes

d$TOTDIABETES <- ifelse(d$DiabetesDiagnosedByDoctor.0.0 == 1 |d$DiabetesDiagnosedByDoctor.1.0 ==1 | d$DiabetesDiagnosedByDoctor.2.0 == 1 | d$DiabetesDiagnosedByDoctor.3.0 ==1, 1, 0)

d$TOTDIABETES[is.na(d$TOTDIABETES)]<-0

d$GESTDIABETES <- ifelse(d$GestationalDiabetesOnly.0.0 == 1 |d$GestationalDiabetesOnly.1.0 ==1 | d$GestationalDiabetesOnly.2.0 == 1 | d$GestationalDiabetesOnly.3.0 == 1, 1, 0)

d$GESTDIABETES[is.na(d$GESTDIABETES)]<-0

d$YOUNGDIABETES <- ifelse(d$AgeDiabetesDiagnosed.0.0 <= 36 | d$AgeDiabetesDiagnosed.1.0 <= 36 | d$AgeDiabetesDiagnosed.2.0 <= 36| d$AgeDiabetesDiagnosed.3.0 <= 36, 1, 0)

d$YOUNGDIABETES[is.na(d$YOUNGDIABETES)]<-0

d$HBA1C_new.0.0 <- ifelse(d$GlycatedHaemoglobin.Hba1C.0.0 >=184, NA, d$GlycatedHaemoglobin.Hba1C.0.0)
d$HBA1C_new.1.0 <- ifelse(d$GlycatedHaemoglobin.Hba1C.1.0 >=184, NA, d$GlycatedHaemoglobin.Hba1C.1.0)
d$HIGHHBA1C <- ifelse(d$HBA1C_new.0.0 >= 48 | d$HBA1C_new.1.0 >= 48,1,0)

# This is the final diabetes variable 

d$DIABETESFINAL <- ifelse((d$TOTDIABETES ==1 | d$HIGHHBA1C ==1) & d$GESTDIABETES != 1 & d$YOUNGDIABETES !=1, 1, 0)
d$DIABETESFINAL[is.na(d$DIABETESFINAL)]<-0



# Write to file. We'll do csv to be able to combine with genotype data
draw <- d
save(draw, file="<USER>/UKB_files/ICD_outcome_raw.rda")

d$feid <- d$f.eid
d2 <- d %>% select(-contains(c('DateOfFirst','OperativeProcedures', 'Diagnoses_', 'Contributory.Secondary.CausesOfDeath.','DateOfCancerDiagnosis','TypeOfCancer', 'Treatment.MedicationCode','Non_CancerIllnessCodeSelf', 'MedicationForCholesterolBloodPressureDiabetes' )))

save(d, file="<USER>/UKB_files/ICD_outcome_cleaned.rda")



message('Done!')
#######################################
#######################################