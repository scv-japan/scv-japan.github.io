# ----------------------------------------
# file name: YADO.PL
# ----------------------------------------
$logdata = 'wsscv.log.data';
# ----------------------------------------
print "!名前              19日      20日      21日      22日      部屋\n";
print "-------------------------------------------------------------------------------\n";
# ----------------------------------------
open(IN, $logdata) || die "$logdata: $!";
while (<IN>){
	chomp;
	($id, $val) = split(/:\t/, $_);
	if ($id eq '名前'){
		($kname) = split(/\t/, $val); $kname =~ s/ //g;
	}
	if ($id eq '19日'){
		$day19 = $val; $day19 =~ s/\t\t/- - /g;
	}
	if ($id eq '20日'){
		$day20 = $val;
	}
	if ($id eq '21日'){
		$day21 = $val;
	}
	if ($id eq '22日'){
		$day22 = $val; $day22 =~ s/   \[1 = 必要, 0 = 不要\]/ - -/g;
	}
	if ($id eq '部屋'){
		$room = $val; $room =~ s/\(なし\)//g;
	}
	if ($id eq '同室者'){
		$mate = $val; $mate =~ s/\(なし\)//g; $mate =~ s/ //g;
		write;
	}
}
close(IN);
# ----------------------------------------
open(IN, $logdata) || die "$logdata: $!";
while (<IN>){
	chomp;
	($id, $val) = split(/:\t/, $_);
	if ($id eq 'Name'){
		$kname = $val;
	}
	if ($id eq '19'){
		$day19 = $val; $day19 =~ s/\t\t/- - /g;
	}
	if ($id eq '20'){
		$day20 = $val;
	}
	if ($id eq '21'){
		$day21 = $val;
	}
	if ($id eq '22'){
		$day22 = $val;
		$day22 =~ s/   \[1 = reserved, 0 = not reserved\]/ - -/g;
	}
	if ($id eq 'Room'){
		$room = $val; $room =~ s/\(none\)//g;
	}
	if ($id eq 'Share with'){
		$mate = $val; $mate =~ s/\(none\)//g;
		write;
	}
}
close(IN);
# ----------------------------------------
format =
@<<<<<<<<<<<<<<<< @<<<<<<<< @<<<<<<<< @<<<<<<<< @<<<<<<<< @<<<<< @<<<<<<<<<<<<<
$kname, $day19, $day20, $day21, $day22, $room, $mate
.
# ----------------------------------------
