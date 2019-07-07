* Fluctuation in Risk and the Business Cycle
* VAR model 


clear 

*********************************************************************
* prepare the dataset
*********************************************************************
* set the dates variables; the original date is counted daily
* first generate Date with "YMD" format and then transfer it quarter series 
* with qofd 
gen Date = date(date, "YMD")
format Date %td  
gen yq = qofd(Date)
tsset yq, quarterly

* generate the growth rates in percentage unit
gen rinvrt = D1.rinv*100
gen rgdprt = D1.rgdp*100
gen rconrt = D1.rcon*100
gen sp500rt = D1.sp500in*100

* calculate the standard deviation 
summarize rinvrt rgdprt rconrt sp500rt

*********************************************************************
* Unit Root Test
*********************************************************************
* Unit root test for hours, infla, sp500in, aaa10y, baa10y
* for rgdp, rinv,.. those variables are well know to have unit root,
* therefore they are not tested for unit root

* hours
varsoc D1.hours, maxlag(5)
* AIC, lags = 1
dfuller hours, drift lags(1) regress
* hypothesis is rejected, so there is no unit root for hours
gen hoursrt = D1.hours*100

* inflation
varsoc D1.infla, maxlag(5)
* AIC suggests lags = 4
dfuller infla, drift lags(4) regress
* hypothesis is rejected, so there is no unit root for inflation

*Sp500

varsoc D1.sp500in, maxlag(5)
* AIC suggests lags = 0
dfuller sp500in, drift lags(0) regress 
* the hytothesis is not rejected, so there is unit root for SP500

* bond yield 

varsoc D1.aaa10y, maxlag(5)
* AIC suggests lags = 2
dfuller aaa10y, drift lags(2) regress
* hypothesis is rejected, so there is no unit root for bond yield

* real wage

varsoc D1.rwage, maxlag(5)
dfuller rwage, drift lags(1) regress

gen rwagert = D1.rwage*100

* labor productivity

varsoc D1.productivity, maxlag(5)
dfuller productivity, drift lags(1) regress 

gen produtrt = D1.productivity

*********************************************************************
* VAR model
*********************************************************************
* variables will be used
* g_y: rgdprt
* g_c: rconrt
* g_I: rinvrt
* H: hours
* R: inrt (interest rate)
* TFP: tfp
* g_sp: sp500rt

* set operation limtis
set matsize 5000
* select the lags

varsoc rgdprt rconrt rinvrt hours rinr tfp sp500rt  if yq < tq(2008Q1), maxlag(8)

* run the model 

var rgdprt rconrt rinvrt hours  rinr tfp sp500rt  if yq < tq(2008Q1), lags(1)

* check the stability
varstable, graph

* check the autocorrelation

varlmar 

* create IRFs 

irf create irf, step(20) bs reps(260) set(var1irf, replace)

irf graph oirf, impulse(rinr) response(rgdprt rconrt rinvrt rinr) byopts(rescale) level(90)

irf graph oirf, impulse(tfp) response(rgdprt rinvrt hours tfp) byopts(rescale) level(90)

irf graph oirf, impulse(hours) response(rgdprt rconrt rinvrt hours) byopts(rescale) level(90)









