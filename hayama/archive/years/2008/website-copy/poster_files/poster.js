// Created by iWeb 2.0.3 local-build-20080213

function createMediaStream_id1()
{return IWCreatePhotocast("file://localhost/Users/hirachi/Desktop/hayama2008/poster_files/rss.xml",false,true);}
function initializeMediaStream_id1()
{createMediaStream_id1().load('file://localhost/Users/hirachi/Desktop/hayama2008',function(imageStream)
{var entryCount=imageStream.length;var headerView=widgets['widget1'];headerView.setPreferenceForKey(imageStream.length,'entryCount');NotificationCenter.postNotification(new IWNotification('SetPage','id1',{pageIndex:0}));});}
function layoutMediaGrid_id1(range)
{createMediaStream_id1().load('file://localhost/Users/hirachi/Desktop/hayama2008',function(imageStream)
{if(range==null)
{range=new IWRange(0,imageStream.length);}
IWLayoutPhotoGrid('id1',new IWPhotoGridLayout(2,new IWSize(248,248),new IWSize(248,32),new IWSize(306,295),27,27,0,new IWSize(2,2)),new IWEmptyStroke(),imageStream,range,new IWShadow({blurRadius:10,offset:new IWPoint(4.2426,4.2426),color:'#000000',opacity:0.750000}),null,1.000000,null,'Media/slideshow.html','widget1','widget2','widget3')});}
function relayoutMediaGrid_id1(notification)
{var userInfo=notification.userInfo();var range=userInfo['range'];layoutMediaGrid_id1(range);}
function onStubPage()
{var args=getArgs();parent.IWMediaStreamPhotoPageSetMediaStream(createMediaStream_id1(),args.id);}
if(window.stubPage)
{onStubPage();}
setTransparentGifURL('Media/transparent.gif');function hostedOnDM()
{return false;}
function onPageLoad()
{IWRegisterNamedImage('comment overlay','Media/Photo-Overlay-Comment.png')
IWRegisterNamedImage('movie overlay','Media/Photo-Overlay-Movie.png')
IWRegisterNamedImage('contribution overlay','Media/Photo-Overlay-Contribution.png')
loadMozillaCSS('poster_files/posterMoz.css')
NotificationCenter.addObserver(null,relayoutMediaGrid_id1,'RangeChanged','id1')
Widget.onload();fixAllIEPNGs('Media/transparent.gif');fixupIECSS3Opacity('id2');initializeMediaStream_id1()
performPostEffectsFixups()}
function onPageUnload()
{Widget.onunload();}
