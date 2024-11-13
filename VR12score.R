###############################################################################
# This program creates a function called vr12score which calculates the       # 
# VR-12 Physical Composite Score (PCS) and Mental Composite Score (MCS) using #
# R statistical software                                                      #
# The function 'vr12score' has 3 possible arguments                           #
#  1) file.in:     The file path to the CSV data set that contains the raw    #  
#                  VR-12 data                                                 #
#  2) file.out:    The file path and name to which a new CSV file will be     #   
#                  created that contains the original data and the new PCS    #
#                  and MCS columns.  If NULL, then 'file.in' will be          #
#                  overwritten with the new data set created with PCS and MCS #
#  3) keyfilepath: The file path to the folder that contains the four CSV     #
#                  coefficients data files.  Defaults to the current working  #
#                  directory (getwd).  Error will occur if correct folder     #
#                  is not given.                                              #
###############################################################################


###############################################################################
# vr12score Requirements:                                                     #
# 1)  'file.in' must be a CSV document with the first row being column names. #
#     Blanks or 'NA' are considered missing values                            #
# 2)  'file.in' must contain column names: Survey, GH1, PF02, PF04, VRP2,     #
#     VRP3, VRE2, VRE3, BP2, MH3, VT2, MH4, and SF2 (specific order is not    #
#     needed, but capitalization must match exactly or error will be printed) #
# 3)  column 'Survey' (Mail or Phone) must have entries that all at least     #
#     start with m/M or p/P                                                   #
# 4)  the other columns, listed in 2), entries must be whole numbers that are #
#     possible values for each column.  If not an error will be printed.      #
# 5)  CSV data files by the names: mcs90_vr12_mar14_native_mail.csv,          # 
#     mcs90_vr12_mar14_native_phone.csv,                                      #
#     pcs90_vr12_mar14_native_mail.csv, and                                   #
#     pcs90_vr12_mar14_native_phone.csv.  Must be in keyfilepath folder       #
###############################################################################

###############################################################################
#  Creator:  Scott J Hetzel MS                                                #
#  Title:  Associate Researcher                                               #
#  Affiliation: University of Wisconsin - Madison                             #
#  Department:  Biostatistics and Medical Informatics                         #
#  Email:  hetzel@biostat.wisc.edu                                            #
#  Date:  12/15/2014                                                          #
#  R version:  R 3.0.1                                                        #
###############################################################################

vr12score <- function(file.in,file.out=NULL,keyfilepath=NULL)
  {
    #  Load CSV data set from file.in
    vr12data <- read.csv(file.in,header=TRUE,na.strings=c("NA",""))

    #  Make sure column names contain: "Survey","GH1","PF02","PF04","VRP2","VRP3",
    #  "VRE2","VRE3","BP2","MH3","VT2","MH4", and "SF2"
    varlist <- c("Survey","GH1","PF02","PF04","VRP2","VRP3","VRE2","VRE3","BP2","MH3","VT2","MH4","SF2")
    if(sum(!(varlist %in% colnames(vr12data)))>0)
      stop(paste("Column names of the original data file must contain:",paste(varlist,collapse=", "),sep=""))

    #  Check that Survey is a factor or character
    if(!is.factor(vr12data[["Survey"]])&!is.character(vr12data[["Survey"]]))
      stop("Column Survey needs to be a factor or a character vector")
    else
      { # Check to make sure all Survey rows start with m/M or p/P
        if(sum(levels(as.factor(substr(levels(as.factor(vr12data[["Survey"]])),1,1))) %in% c("m","M","p","P"))
           != nlevels(as.factor(substr(levels(as.factor(vr12data[["Survey"]])),1,1))))
          stop("There is at least 1 entry in Survey that doesn't start with m/M or p/P")
      }
    #  Check that each data column is numeric
    for(j in 2:length(varlist))
      {
        if(!is.numeric(vr12data[[varlist[j]]]))
      stop(paste("Column ",varlist[j], " needs to be numeric ",sep=""))
        else 
          {#  Now check if each column has the correct possible values
            if(j %in% c(2,5,6,7,8,9,13))
              numlist <- as.factor(1:5)
            else if(j %in% c(3,4))
              numlist <- as.factor(1:3)
            else
              numlist <- as.factor(1:6)
            if(sum(levels(as.factor(vr12data[[varlist[j]]])) %in% numlist) != nlevels(as.factor(vr12data[[varlist[j]]])))
          stop(paste("There is at least 1 entry in ", varlist[j], " that isn't an appropriate value: ",
                     paste(numlist,collapse=", "),sep=""))
          }
      }     
      
    #  Create 0-100 point scales of the items
    vr12data[["gh1x"]] <- ifelse(vr12data[["GH1"]]==1,100,
                                 ifelse(vr12data[["GH1"]]==2,85,
                                        ifelse(vr12data[["GH1"]]==3,60,
                                               ifelse(vr12data[["GH1"]]==4,35,0))))
    vr12data[["pf02x"]] <- (vr12data[["PF02"]]-1)*50
    vr12data[["pf04x"]] <- (vr12data[["PF04"]]-1)*50
    vr12data[["rp2x"]] <- (5-vr12data[["VRP2"]])*25
    vr12data[["rp3x"]] <- (5-vr12data[["VRP3"]])*25
    vr12data[["re2x"]] <- (5-vr12data[["VRE2"]])*25
    vr12data[["re3x"]] <- (5-vr12data[["VRE3"]])*25
    vr12data[["bp2x"]] <- (5-vr12data[["BP2"]])*25
    vr12data[["mh3x"]] <- (6-vr12data[["MH3"]])*20
    vr12data[["vt2x"]] <- (6-vr12data[["VT2"]])*20
    vr12data[["mh4x"]] <- (vr12data[["MH4"]]-1)*20
    vr12data[["sf2x"]] <- (vr12data[["SF2"]]-1)*25

    #  Calculate the key value, if value is missing assign it 2 to corresponding power, if not then 0
    key.slots <- data.frame("gh1k"=ifelse(is.na(vr12data[["GH1"]]),2^11,0),
                            "pf02k"=ifelse(is.na(vr12data[["PF02"]]),2^10,0),
                            "pf04k"=ifelse(is.na(vr12data[["PF04"]]),2^9,0),
                            "rp2k"=ifelse(is.na(vr12data[["VRP2"]]),2^8,0),
                            "rp3k"=ifelse(is.na(vr12data[["VRP3"]]),2^7,0),
                            "re2k"=ifelse(is.na(vr12data[["VRE2"]]),2^6,0),
                            "re3k"=ifelse(is.na(vr12data[["VRE3"]]),2^5,0),
                            "bp2k"=ifelse(is.na(vr12data[["BP2"]]),2^4,0),
                            "mh3k"=ifelse(is.na(vr12data[["MH3"]]),2^3,0),
                            "vt2k"=ifelse(is.na(vr12data[["VT2"]]),2^2,0),
                            "mh4k"=ifelse(is.na(vr12data[["MH4"]]),2^1,0),
                            "sf2k"=ifelse(is.na(vr12data[["SF2"]]),2^0,0))
    #  Create key column
    vr12data[["key"]] <- apply(key.slots,1,sum)
    
    #  Load external key coefficient data sets
    if(is.null(keyfilepath))
      keyfilepath <- getwd()

    #  Load key coefficient CSV data files that contain coefficients based on key
    mcsMail <- read.csv(paste(keyfilepath,"/mcs90_vr12_mar14_native_mail.csv",sep=""),header=TRUE)
    mcsPhone <- read.csv(paste(keyfilepath,"/mcs90_vr12_mar14_native_phone.csv",sep=""),header=TRUE)
    pcsMail <- read.csv(paste(keyfilepath,"/pcs90_vr12_mar14_native_mail.csv",sep=""),header=TRUE)
    pcsPhone <- read.csv(paste(keyfilepath,"/pcs90_vr12_mar14_native_phone.csv",sep=""),header=TRUE)
    
    #  Run a for loop to get MCS and PCS scores for each subject
    #  Set default setting for MSC column
    vr12data[["PCS"]] <- NA
    vr12data[["MCS"]] <- NA
    
    for(i in 1:length(vr12data[["key"]]))
      {
        if(substr(vr12data[["Survey"]][i],1,1)=="m"|substr(vr12data[["Survey"]][i],1,1)=="M")  # Subset based on Mail survey
          {
            #  Calculate MCS based on the key and mail survey
            if(vr12data[["key"]][i] %in% mcsMail$key)
              {
                vr12data[["MCS"]][i] <- sum(c(vr12data[["gh1x"]][i],vr12data[["pf02x"]][i],vr12data[["pf04x"]][i],vr12data[["rp2x"]][i],
                                              vr12data[["rp3x"]][i],vr12data[["re2x"]][i],vr12data[["re3x"]][i],vr12data[["bp2x"]][i],
                                              vr12data[["mh3x"]][i],vr12data[["vt2x"]][i],vr12data[["mh4x"]][i],vr12data[["sf2x"]][i])*
                                            c(mcsMail$gh1x[mcsMail$key==vr12data[["key"]][i]],mcsMail$pf02x[mcsMail$key==vr12data[["key"]][i]],
                                              mcsMail$pf04x[mcsMail$key==vr12data[["key"]][i]],mcsMail$rp2x[mcsMail$key==vr12data[["key"]][i]],
                                              mcsMail$rp3x[mcsMail$key==vr12data[["key"]][i]],mcsMail$re2x[mcsMail$key==vr12data[["key"]][i]],
                                              mcsMail$re3x[mcsMail$key==vr12data[["key"]][i]],mcsMail$bp2x[mcsMail$key==vr12data[["key"]][i]],
                                              mcsMail$mh3x[mcsMail$key==vr12data[["key"]][i]],mcsMail$vt2x[mcsMail$key==vr12data[["key"]][i]],
                                              mcsMail$mh4x[mcsMail$key==vr12data[["key"]][i]],mcsMail$sf2x[mcsMail$key==vr12data[["key"]][i]]),
                                            na.rm=TRUE)+mcsMail$cons[mcsMail$key==vr12data[["key"]][i]]
              }
            else  # key isn't in MCS mail survey
              vr12data[["MCS"]][i] <- NA

            #  Calculate PCS based on the key and mail survey
            if(vr12data[["key"]][i] %in% pcsMail$key)
              {
                vr12data[["PCS"]][i] <- sum(c(vr12data[["gh1x"]][i],vr12data[["pf02x"]][i],vr12data[["pf04x"]][i],vr12data[["rp2x"]][i],
                                              vr12data[["rp3x"]][i],vr12data[["re2x"]][i],vr12data[["re3x"]][i],vr12data[["bp2x"]][i],
                                              vr12data[["mh3x"]][i],vr12data[["vt2x"]][i],vr12data[["mh4x"]][i],vr12data[["sf2x"]][i])*
                                            c(pcsMail$gh1x[pcsMail$key==vr12data[["key"]][i]],pcsMail$pf02x[pcsMail$key==vr12data[["key"]][i]],
                                              pcsMail$pf04x[pcsMail$key==vr12data[["key"]][i]],pcsMail$rp2x[pcsMail$key==vr12data[["key"]][i]],
                                              pcsMail$rp3x[pcsMail$key==vr12data[["key"]][i]],pcsMail$re2x[pcsMail$key==vr12data[["key"]][i]],
                                              pcsMail$re3x[pcsMail$key==vr12data[["key"]][i]],pcsMail$bp2x[pcsMail$key==vr12data[["key"]][i]],
                                              pcsMail$mh3x[pcsMail$key==vr12data[["key"]][i]],pcsMail$vt2x[pcsMail$key==vr12data[["key"]][i]],
                                              pcsMail$mh4x[pcsMail$key==vr12data[["key"]][i]],pcsMail$sf2x[pcsMail$key==vr12data[["key"]][i]]),
                                            na.rm=TRUE)+pcsMail$cons[pcsMail$key==vr12data[["key"]][i]]
              }
            else  # key isn't in PCS mail survey
              vr12data[["PCS"]][i] <- NA
          }
        else if(substr(vr12data[["Survey"]][i],1,1)=="p"|substr(vr12data[["Survey"]][i],1,1)=="P")  # Subset based on Phone survey
          {
            #  Calculate MCS based on the key and phone survey
            if(vr12data[["key"]][i] %in% mcsPhone$key)
              {
                vr12data[["MCS"]][i] <- sum(c(vr12data[["gh1x"]][i],vr12data[["pf02x"]][i],vr12data[["pf04x"]][i],vr12data[["rp2x"]][i],
                                              vr12data[["rp3x"]][i],vr12data[["re2x"]][i],vr12data[["re3x"]][i],vr12data[["bp2x"]][i],
                                              vr12data[["mh3x"]][i],vr12data[["vt2x"]][i],vr12data[["mh4x"]][i],vr12data[["sf2x"]][i])*
                                            c(mcsPhone$gh1x[mcsPhone$key==vr12data[["key"]][i]],mcsPhone$pf02x[mcsPhone$key==vr12data[["key"]][i]],
                                              mcsPhone$pf04x[mcsPhone$key==vr12data[["key"]][i]],mcsPhone$rp2x[mcsPhone$key==vr12data[["key"]][i]],
                                              mcsPhone$rp3x[mcsPhone$key==vr12data[["key"]][i]],mcsPhone$re2x[mcsPhone$key==vr12data[["key"]][i]],
                                              mcsPhone$re3x[mcsPhone$key==vr12data[["key"]][i]],mcsPhone$bp2x[mcsPhone$key==vr12data[["key"]][i]],
                                              mcsPhone$mh3x[mcsPhone$key==vr12data[["key"]][i]],mcsPhone$vt2x[mcsPhone$key==vr12data[["key"]][i]],
                                              mcsPhone$mh4x[mcsPhone$key==vr12data[["key"]][i]],mcsPhone$sf2x[mcsPhone$key==vr12data[["key"]][i]]),
                                            na.rm=TRUE)+mcsPhone$cons[mcsPhone$key==vr12data[["key"]][i]]
              }
            else  # key isn't in MCS phone survey
              vr12data[["MCS"]][i] <- NA

            #  Calculate PCS based on the key and phone survey
            if(vr12data[["key"]][i] %in% pcsPhone$key)
              {
                vr12data[["PCS"]][i] <- sum(c(vr12data[["gh1x"]][i],vr12data[["pf02x"]][i],vr12data[["pf04x"]][i],vr12data[["rp2x"]][i],
                                              vr12data[["rp3x"]][i],vr12data[["re2x"]][i],vr12data[["re3x"]][i],vr12data[["bp2x"]][i],
                                              vr12data[["mh3x"]][i],vr12data[["vt2x"]][i],vr12data[["mh4x"]][i],vr12data[["sf2x"]][i])*
                                            c(pcsPhone$gh1x[pcsPhone$key==vr12data[["key"]][i]],pcsPhone$pf02x[pcsPhone$key==vr12data[["key"]][i]],
                                              pcsPhone$pf04x[pcsPhone$key==vr12data[["key"]][i]],pcsPhone$rp2x[pcsPhone$key==vr12data[["key"]][i]],
                                              pcsPhone$rp3x[pcsPhone$key==vr12data[["key"]][i]],pcsPhone$re2x[pcsPhone$key==vr12data[["key"]][i]],
                                              pcsPhone$re3x[pcsPhone$key==vr12data[["key"]][i]],pcsPhone$bp2x[pcsPhone$key==vr12data[["key"]][i]],
                                              pcsPhone$mh3x[pcsPhone$key==vr12data[["key"]][i]],pcsPhone$vt2x[pcsPhone$key==vr12data[["key"]][i]],
                                              pcsPhone$mh4x[pcsPhone$key==vr12data[["key"]][i]],pcsPhone$sf2x[pcsPhone$key==vr12data[["key"]][i]]),
                                            na.rm=TRUE)+pcsPhone$cons[pcsPhone$key==vr12data[["key"]][i]]
              }
            else  # key isn't in PCS phone survey
              vr12data[["PCS"]][i] <- NA
          }
      }
    #  Export the vr12data file to either rewrite file.in or to write a new file to file.out
    if(is.null(file.out))
      write.csv(vr12data,file=file.in,row.names=FALSE)
    else
      write.csv(vr12data,file=file.out,row.names=FALSE)
  }
