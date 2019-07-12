/* Port of strftime() by T. H. Doan (https://thdoan.github.io/strftime/)
 *
 * Day of year (%j) code based on Joe Orost's answer:
 * http://stackoverflow.com/questions/8619879/javascript-calculate-the-day-of-the-year-1-366
 *
 * Week number (%V) code based on Taco van den Broek's prototype:
 * http://techblog.procurios.nl/k/news/view/33796/14863/calculate-iso-8601-week-and-year-in-javascript.html
 */
function strftime(e,t){t instanceof Date||(t=new Date);var a=t.getDay(),r=t.getDate(),n=t.getMonth(),i=t.getFullYear(),u=t.getHours(),o=["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],c=["January","February","March","April","May","June","July","August","September","October","November","December"],l=[0,31,59,90,120,151,181,212,243,273,304,334],g=function(){var e=new Date(t);return e.setDate(r-(a+6)%7+3),e},s=function(e,t){return(Math.pow(10,t)+e+"").slice(1)};return e.replace(/%[a-z]/gi,function(e){return({"%a":o[a].slice(0,3),"%A":o[a],"%b":c[n].slice(0,3),"%B":c[n],"%c":t.toUTCString(),"%C":Math.floor(i/100),"%d":s(r,2),"%e":r,"%F":t.toISOString().slice(0,10),"%G":g().getFullYear(),"%g":(g().getFullYear()+"").slice(2),"%H":s(u,2),"%I":s((u+11)%12+1,2),"%j":s(l[n]+r+(n>1&&(i%4==0&&i%100!=0||i%400==0)?1:0),3),"%k":u,"%l":(u+11)%12+1,"%m":s(n+1,2),"%n":n+1,"%M":s(t.getMinutes(),2),"%p":u<12?"AM":"PM","%P":u<12?"am":"pm","%s":Math.round(t.getTime()/1e3),"%S":s(t.getSeconds(),2),"%u":a||7,"%V":function(){var e=g(),t=e.valueOf();e.setMonth(0,1);var a=e.getDay();return 4!==a&&e.setMonth(0,1+(4-a+7)%7),s(1+Math.ceil((t-e)/6048e5),2)}(),"%w":a,"%x":t.toLocaleDateString(),"%X":t.toLocaleTimeString(),"%y":(i+"").slice(2),"%Y":i,"%z":t.toTimeString().replace(/.+GMT([+-]\d+).+/,"$1"),"%Z":t.toTimeString().replace(/.+\((.+?)\)$/,"$1")}[e]||"")+""||e})}
