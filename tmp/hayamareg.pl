#!/usr/bin/perl
#==============================================================================
#	file name : hayamareg.pl (Ver.1.00)
#	Perl CGI script for the online registration for the attendance
#	at Hayama Symposium on Several Complex Variables 1997
#			first created on 06/05/97 by Makoto ABE
#			last modified on 12/03/97 by Makoto ABE
#==============================================================================
print "Content-type: text/html\n\n";
# ----------------------------------------
@day     = (17, 18, 19, 20);
$year    = '1999';
%charset = ('ja' => 'euc-jp', 'en' => 'iso-8859-1');
$manager = 'abel@rc.kyushu-u.ac.jp';
$sendmail= '/usr/lib/sendmail -t -n -oi';
$nkf     = '/usr/bin/nkf';
$logform = '/var/log/hayama99.log.form';
$logdata = '/var/log/hayama99.log.data';
require    '/home/httpd/cgi-bin/jcode.pl';
# ----------------------------------------
$ENV{'REQUEST_METHOD'} =~ tr/a-z/A-Z/;
if ($ENV{'REQUEST_METHOD'} eq "POST") {
	read (STDIN, $form, $ENV{'CONTENT_LENGTH'});
} else {
	$form = $ENV{'QUERY_STRING'};
}
@parts = split(/&/, $form);
foreach $part (@parts) {
	($id, $val) = split(/=/, $part);
	$val =~ tr/+/ /;
	$val =~ s/%([0-9a-fA-F][0-9a-fA-F])/pack("C", hex($1))/eg;
	&jcode::convert(*val, 'euc');
#	&jcode::h2z_euc(*_,);
	$val =~ s/\015\012/ /g;
	$val =~ s/\012/ /g;
	$val =~ s/\015/ /g;
	$val =~ s/\t/ /g;
	$val =~ s/　/ /g;
	$val =~ s/</&lt;/g;
	$val =~ s/>/&gt;/g;
	$data{$id} = $val;
}
# ----------------------------------------
$lang  = $data{lang};
$rname = $data{rname}; $rname =~ s/ +/ /g; $rname =~ s/(^ | $)//g;
$kname = $data{kname}; $kname =~ s/ +/ /g; $kname =~ s/(^ | $)//g;
$affil = $data{affil}; $affil =~ s/ +/ /g; $affil =~ s/(^ | $)//g;
$posit = $data{posit}; $posit =~ s/ +/ /g; $posit =~ s/(^ | $)//g;
$age   = $data{age};   $age   =~ s/ //g;
$email = $data{email}; $email =~ s/ //g;
$addr  = $data{addr};  $addr  =~ s/ +/ /g; $addr  =~ s/(^ | $)//g;
$phone = $data{phone}; $phone =~ s/ +/ /g; $phone =~ s/(^ | $)//g;
$supp  = $data{supp};
$begin = $data{begin}; $begin  =~ s/ //g;
$end   = $data{end};   $end    =~ s/ //g;
$hkshu = $data{hkshu}; $hkshu  =~ s/ //g;
	$hkshu =~ s/1/一/g; $hkshu =~ s/2/二/g; $hkshu =~ s/3/三/g;
	$hkshu =~ s/4/四/g; $hkshu =~ s/5/五/g; $hkshu =~ s/6/六/g;
	$hkshu =~ s/7/七/g; $hkshu =~ s/8/八/g; $hkshu =~ s/9/九/g;
$hkkyu = $data{hkkyu}; $hkkyu  =~ s/ //g;
$hkgoh = $data{hkgoh}; $hkgoh  =~ s/ //g;
@brf = (0, $data{brf1}+0, $data{brf2}+0, $data{brf3}+0, $data{brf4}+0);
@lun = (0, $data{lun1}+0, $data{lun2}+0, $data{lun3}+0, $data{lun4}+0);
@din = ($data{din0}+0, $data{din1}+0, $data{din2}+0, $data{din3}+0, 0);
@lod = ($data{lod0}+0, $data{lod1}+0, $data{lod2}+0, $data{lod3}+0, 0);
$room  = $data{room};
$mate  = $data{mate};  $mate  =~ s/ +/ /g; $mate  =~ s/(^ | $)//g;
$party = $data{party};
# ----------------------------------------
($lsec, $lmin, $lhour, $lmday, $lmon, $lyear, $lwday) = localtime;
$lsec  = substr(('0' . $lsec    ), -2, 2);
$lmin  = substr(('0' . $lmin    ), -2, 2);
$lhour = substr(('0' . $lhour   ), -2, 2);
$lmday = substr(('0' . $lmday   ), -2, 2);
$lmon  = substr(('0' . ($lmon+1)), -2, 2);
# ----------------------------------------
sub tabulate ($) {
	my ($HANDLE) = @_[0];
	print $HANDLE "----- $lmon/$lmday/$lyear $lhour:$lmin:$lsec (JST) -----\n";
	if ($lang eq 'ja') {
		if ($kname eq '') {
			print $HANDLE "名前:\t$rname\n";
		} else {
			print $HANDLE "名前:\t$kname\t($rname)\n";
		}
		if ($affil eq '') {
			print $HANDLE "所属:\t(なし)\n";
		} else {
			print $HANDLE "所属:\t$affil\n";
		}
		if ($posit eq '') {
			print $HANDLE "職名:\t(なし)\n";
		} else {
			print $HANDLE "職名:\t$posit\n";
		}
		if ($age eq '') {
			print $HANDLE "年齢:\t(なし)\n";
		} else {
			print $HANDLE "年齢:\t$age\n";
		}
		print $HANDLE "e-mail:\t$email\n";
		if ($addr eq '') {
			print $HANDLE "住所:\t(なし)\n";
		} else {
			print $HANDLE "住所:\t$addr\n";
		}
		if ($phone eq '') {
			print $HANDLE "電話:\t(なし)\n";
		} else {
			print $HANDLE "電話:\t$phone\n";
		}
		print $HANDLE "補助:\t$supp\n";
		if (($begin eq '') and ($end eq '')) {
			print $HANDLE "期間:\t(なし)\n";
		} else {
			print $HANDLE "期間:\t$begin 日から $end 日まで\n";
		}
		if (($hkshu eq '') and ($hkkyu eq '') and ($hkgoh eq '')) {
			print $HANDLE "俸給:\t(なし)\n";
		} else {
			print $HANDLE "俸給:\t教($hkshu) $hkkyu 級 $hkgoh 号俸\n";
		}
		print $HANDLE "$day[0]日:\t\t\t$din[0]\t$lod[0]\n";
		print $HANDLE "$day[1]日:\t$brf[1]\t$lun[1]\t$din[1]\t$lod[1]\n";
		print $HANDLE "$day[2]日:\t$brf[2]\t$lun[2]\t$din[2]\t$lod[2]\n";
		print $HANDLE "$day[3]日:\t$brf[3]\t$lun[3]";
		print $HANDLE "   [1 = 必要, 0 = 不要]\n";
		if ($room eq '') {
			print $HANDLE "部屋:\t(なし)\n";
		} else {
			print $HANDLE "部屋:\t$room\n";
		}
		if ($mate eq '') {
			print $HANDLE "同室者:\t(なし)\n";
		} else {
			print $HANDLE "同室者:\t$mate\n";
		    };
	       
	        print $HANDLE "懇親会:\t$party\n";
                    		




	} else {
		print $HANDLE "Name:\t$rname\n";
		if ($affil eq '') {
			print $HANDLE "Inst.:\t(none)\n";
		} else {
			print $HANDLE "Inst.:\t$affil\n";
		}
		print $HANDLE "E-mail:\t$email\n";
		if ($addr eq '') {
			print $HANDLE "Addr.:\t(none)\n";
		} else {
			print $HANDLE "Addr.:\t$addr\n";
		}
		if ($phone eq '') {
			print $HANDLE "Phone:\t(none)\n";
		} else {
			print $HANDLE "Phone:\t$phone\n";
		}
		print $HANDLE "$day[0]:\t\t\t$din[0]\t$lod[0]\n";
		print $HANDLE "$day[1]:\t$brf[1]\t$lun[1]\t$din[1]\t$lod[1]\n";
		print $HANDLE "$day[2]:\t$brf[2]\t$lun[2]\t$din[2]\t$lod[2]\n";
		print $HANDLE "$day[3]:\t$brf[3]\t$lun[3]";
		print $HANDLE "   [1 = reserved, 0 = not reserved]\n";
		if ($room eq '') {
			print $HANDLE "Room:\t(none)\n";
		} else {
			print $HANDLE "Room:\t$room\n";
		}
		if ($mate eq '') {
			print $HANDLE "Share with:\t(none)\n";
		} else {
			print $HANDLE "Share with:\t$mate\n";
		    };
	        print $HANDLE "Banquet:\t$party\n";

               
	}
}
# ----------------------------------------
if (($rname eq '') or ($email eq '')) {
	die;
};
# ----------------------------------------
open(FILE, ">>$logform") || die;
print FILE "$form\n";
close(FILE);
# ----------------------------------------
open(FILE, ">>$logdata") || die;
print FILE "[HP($lang)] ";
tabulate('FILE');
close(FILE);
# ----------------------------------------
open(MAIL, "| $nkf -j | $sendmail") || die;
print MAIL "To: $manager\n";
print MAIL "Subject: Registration\n\n";
print MAIL "[HP($lang)] ";
tabulate('MAIL');
close(MAIL);
# ----------------------------------------
print "<HTML>\n";
print "<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=$charset{$lang}\">\n";
print "<TITLE>Confirm the registration</TITLE>\n";
print "<BODY TEXT=\"#000000\" BGCOLOR=\"#A0FFA0\">\n";
print "<PRE>\n";
if ($lang eq 'ja') {
	print "あなたは $year 年度多変数関数論葉山シンポジウムへの参加に関\n";
	print "して, 下記の通りに記入されました。なお, 出張旅費の補助など\n";
	print "の件で御希望に添えない場合がありましても御了承頂きたくよろ\n";
	print "しくお願い致します。\n\n";
} else {
	print "You submitted the registration form  for the attendance at\n";
	print "Hayama Symposium  on Several Complex Variables  which will\n";
	print "be held on December $day[0] - $day[3], $year.  It is as follows:\n\n";
}
tabulate('STDOUT');
print "</PRE>\n";
print "<HR>\n";
print "<PRE>\n";
if ($lang eq 'ja') {
	print "上記の文書と同じものを e-mail でも直ちにお送りしました。\n";
} else {
	print "You will also receive immediately the same confirmation as\n";
	print "above by e-mail.  Thank you!\n";
}
print "</PRE>\n";
print "</BODY>\n";
print "</HTML>\n";
# ----------------------------------------
open(MAIL, "| $nkf -j | $sendmail") || die;
print MAIL "From: $manager\n";
print MAIL "To: $email\n";
print MAIL "Reply-To: $manager\n";
print MAIL "Errors-To: $manager\n";
print MAIL "Subject: Registration\n\n";
if ($lang eq 'ja') {
	print MAIL "あなたは $year 年度多変数関数論葉山シンポジウムへの参加に関\n";
	print MAIL "して, 下記の通りに記入されました。なお, 出張旅費の補助など\n";
	print MAIL "の件で御希望に添えない場合がありましても御了承頂きたくよろ\n";
	print MAIL "しくお願い致します。\n\n";
} else {
	print MAIL "You submitted the registration form  for the attendance at\n";
	print MAIL "Hayama Symposium  on Several Complex Variables  which will\n";
	print MAIL "be held on December $day[0] - $day[3], $year.  It is as follows:\n\n";
}
tabulate('MAIL');
close(MAIL);
# ----------------------------------------








