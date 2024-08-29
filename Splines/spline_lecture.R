library(readr)

d<-3
K<-3
k1<-0.2
k2<-0.5
k3<-0.8
knots<-(k1 k2 k3)

tmp <- read_csv("C:/Users/theand/OneDrive - Karolinska Institutet/BDS/Biostat1/Temp/Splines/tmp.csv", show_col_types = FALSE)

lm1 <- lm(formula=y~x, data=tmp)
summary(lm1)

lm2 <- lm(formula=y~x+I(x^2), data=tmp)
summary(lm2)

lm3 <- lm(formula=y~x+I(x^2)+I(x^3), data=tmp)
summary(lm3)

tmp$int1<-(tmp$x<=k1)*1
tmp$int2<-(tmp$x>k1)*(tmp$x<=k2)
tmp$int3<-(tmp$x>k2)*(tmp$x<=k3)
tmp$int4<-(tmp$x>k3)*1
lm4 <- lm(formula=y~0+int1+int2+int3+int4, data=tmp)
summary(lm4)

tmp$xp1<-tmp$x*(tmp$x<=k1)
tmp$xp2<-tmp$x*(tmp$x>k1)*(tmp$x<=k2)
tmp$xp3<-tmp$x*(tmp$x>k2)*(tmp$x<=k3)
tmp$xp4<-tmp$x*(tmp$x>k3)*1
tmp$xpsq1<-tmp$x^2*(tmp$x<=k1)
tmp$xpsq2<-tmp$x^2*(tmp$x>k1)*(tmp$x<=k2)
tmp$xpsq3<-tmp$x^2*(tmp$x>k2)*(tmp$x<=k3)
tmp$xpsq4<-tmp$x^2*(tmp$x>k3)*1
tmp$xpcub1<-tmp$x^3*(tmp$x<=k1)
tmp$xpcub2<-tmp$x^3*(tmp$x>k1)*(tmp$x<=k2)
tmp$xpcub3<-tmp$x^3*(tmp$x>k2)*(tmp$x<=k3)
tmp$xpcub4<-tmp$x^3*(tmp$x>k3)*1
}
lm4 <- lm(formula=y~0+int1+int2+int3+int4+xp1+xp2+xp3+xp4+xpsq1+xpsq2+xpsq3+xpsq4+xpcub1+xpcub2+xpcub3+xpcub4, data=tmp)
summary(lm4)


tmp$xptr1<-(tmp$x-k1)^3*(tmp$x-k1>0)
tmp$xptr2<-(tmp$x-k2)^3*(tmp$x-k2>0)
tmp$xptr3<-(tmp$x-k3)^3*(tmp$x-k3>0)
lm5<-lm(formula=y~x+I(x^2)+I(x^3)+xptr1+xptr2+xptr3, data=tmp)
summary(lm5)


