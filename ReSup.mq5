//+------------------------------------------------------------------+
//|                                                        reSup.mq5 |
//|                                    Project source code on GitHub |
//|                                  https://github.com/mst219/reSup |
//+------------------------------------------------------------------+
#property copyright "Project source code on GitHub"
#property link      "https://github.com/mst219/reSup"
#property version   "1.00"
#property indicator_chart_window

struct struct_resup{
   datetime time;
   double price;
   char dir;
};
struct_resup resup;

input int resupX=7;// Resistance & Support(Power)

int OnInit(){
   restart();
   return(INIT_SUCCEEDED);
}
int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],const double &open[],const double &high[],const double &low[],const double &close[],const long &tick_volume[],const long &volume[],const int &spread[]){
   if(prev_calculated==0)
		restart();
	
	int count=rates_total-1;
	for(int i=(prev_calculated<resupX?resupX:prev_calculated);i<count;i++){
	   char dir=-1;
		if( close[i]>close[i-1] || ( close[i]==close[i-1] && close[i]>=high[i]-(high[i]-low[i])/2 ) )
			dir=1;
		bool l=true,h=true;
		int x=i-resupX;
		for(int j=i-1;j>=x;j--){
			if(high[i]<high[j])
				h=false;
			if(low[i]>low[j])
				l=false;
		}
		if(dir==1){
			if( l && ( resup.dir!=-1 || low[i]<resup.price ) )
				newReSup(time[i],-1,low[i]);
			if( h && ( resup.dir!=1 || high[i]>resup.price ) )
				newReSup(time[i],1,high[i]);
		}else{// -1
			if( h && ( resup.dir!=1 || high[i]>resup.price ) )
				newReSup(time[i],1,high[i]);
			if( l && ( resup.dir!=-1 || low[i]<resup.price ) )
				newReSup(time[i],-1,low[i]);
		}
	}
	
   return(rates_total);
}
void OnTimer(){}
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam){}
void OnDeinit(const int reason){restart();}

//
void restart(){}
void newReSup(datetime time,char dir,double price){
	if( resup.dir!=0 && resup.dir!=dir ){
		// draw
	}
	resup.time=time;
	resup.dir=dir;
	resup.price=price;
}