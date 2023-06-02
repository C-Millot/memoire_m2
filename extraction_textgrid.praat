

path_wav$ = "dossier"
path_coarticulation$ = "dossier"


result$ = "resultat_coarticulation_nccfr_final_syllabes_et_f0.txt"
fileappend 'result$' file'tab$'diphone'tab$'mot'tab$'mot_suivant'tab$'duree_reelle'tab$'f0_mid_part1'tab$'f0_mid_part2
... 'tab$'meme_syllabe'tab$'pos_syllabe_dans_mot_phone1'tab$'pos_syllabe_dans_mot_phone2
... 'tab$'pos_phoneme_dans_syllabe_phone1'tab$'pos_phoneme_dans_syllabe_phone2
... 'tab$'pos_phoneme_dans_mot_phone1'tab$'pos_phoneme_dans_mot_phone2'newline$'


string_wav = Create Strings as file list: "fileList", "dossier"
nb_wav = Get number of strings

for a from 1 to nb_wav
	printline 'a'
	select 'string_wav'
	nom_file$ = Get string: a
	nom_file_sans_extension$ = nom_file$ - ".wav"
	wav_file$ = path_wav$ + "\" + nom_file_sans_extension$ + ".wav"
	textgrid_file$ = path_wav$ + "\" + nom_file_sans_extension$ +  ".TextGrid"
	son = Open long sound file: "'wav_file$'"
	textgrid = Read from file: "'textgrid_file$'"
	nb_intervals = Get number of intervals: 1
	duration_total = Get end time






	for b from 2 to nb_intervals-3
		select 'textgrid'
		intervalle$ = Get label of interval: 1, b
		if (intervalle$ = "H" or intervalle$ = "." or intervalle$ = "" or intervalle$ = " ")
			intervalle$ = "_"
		endif
		intervalle_suivant$ = Get label of interval: 1, b+1
		if (intervalle_suivant$ = "H" or intervalle_suivant$ = "." or intervalle_suivant$ = "" or intervalle_suivant$ = " ")
			intervalle_suivant$ = "_"	
		endif

		diphone$ = intervalle$ + intervalle_suivant$
		debut_intervalle = Get start time of interval: 1, b
		debut_intervalle_suivant = Get end time of interval: 1, b
		fin_intervalle_suivant = Get end time of interval: 1, b+1
		milieu_intervalle = (debut_intervalle+debut_intervalle_suivant)/2
		milieu_intervalle_suivant = (debut_intervalle_suivant+fin_intervalle_suivant)/2
		duree = round((milieu_intervalle_suivant-milieu_intervalle)*1000)
		mot$ = Get label of interval: 2, b
		mot_suivant$ = Get label of interval: 2, b+1

		interval_syllabe_diphone_part1 = Get interval at time: 6, milieu_intervalle
		interval_syllabe_diphone_part2 = Get interval at time: 6, milieu_intervalle_suivant

		interval_mot_diphone_part1 = Get interval at time: 5, milieu_intervalle
		interval_mot_diphone_part2 = Get interval at time: 5, milieu_intervalle_suivant

################################################################################################################

		if interval_syllabe_diphone_part1 = interval_syllabe_diphone_part2
		meme_syllabe = 1
		endif



################################################################################################################


		if (intervalle$ = "a" or intervalle$ = "A" or intervalle$ = "E" or intervalle$ = "e"
		... or intervalle$ = "i" or intervalle$ = "I" or intervalle$ = "O" or intervalle$ = "A"
		... or intervalle$ = "o" or intervalle$ = "x" or intervalle$ = "@" or intervalle$ = "y"
		... or intervalle$ = "c" or intervalle$ = "u")
		

		select 'son'
		extract = Extract part: milieu_intervalle-0.05, milieu_intervalle+0.05, "yes"
		pitch = To Pitch: 0, 75, 600
		f0_mid_part1 = Get value at time: milieu_intervalle, "Hertz", "Linear"
		f0_mid_part1 = round(f0_mid_part1)
		select 'extract'
		plus 'pitch'
		Remove
		
		else
		f0_mid_part1 = undefined
		endif

################################################################################################################


		if (intervalle_suivant$ = "a" or intervalle_suivant$ = "A" or intervalle_suivant$ = "E" or intervalle_suivant$ = "e"
		... or intervalle_suivant$ = "i" or intervalle_suivant$ = "I" or intervalle_suivant$ = "O" or intervalle_suivant$ = "A"
		... or intervalle_suivant$ = "o" or intervalle_suivant$ = "x" or intervalle_suivant$ = "@" or intervalle_suivant$ = "y"
		... or intervalle_suivant$ = "c" or intervalle_suivant$ = "u")

		select 'son'
		extract = Extract part: milieu_intervalle_suivant-0.05, milieu_intervalle_suivant+0.05, "yes"
		pitch = To Pitch: 0, 75, 600
		f0_mid_part2 = Get value at time: milieu_intervalle_suivant, "Hertz", "Linear"
		f0_mid_part2 = round(f0_mid_part2)

		select 'extract'
		plus 'pitch'
		Remove
		
		else
		f0_mid_part2 = undefined
		endif
		


################################################################################################################
		select 'textgrid'

		fin_mot = Get end time of interval: 5, interval_mot_diphone_part1
		debut_mot_suivant = Get start time of interval: 5, interval_mot_diphone_part1+1
		interval_syllabe_debut_mot_suivant_part1 = Get interval at time: 6, debut_mot_suivant+0.0001
		nb_syllabes_restant_dans_mot_part1 = interval_syllabe_debut_mot_suivant_part1 - interval_syllabe_diphone_part1
		fin_mot_precedent = Get end time of interval: 5, interval_mot_diphone_part1-1
		interval_syllabe_fin_mot_precedent_part1 = Get interval at time: 6, fin_mot_precedent-0.0001
		nb_syllabes_total_dans_mot = interval_syllabe_debut_mot_suivant_part1 -  interval_syllabe_fin_mot_precedent_part1 - 1
		position_syllabe_dans_mot_part1 = nb_syllabes_total_dans_mot - nb_syllabes_restant_dans_mot_part1 + 1
		position_syllabe_dans_mot_part1$ = "'position_syllabe_dans_mot_part1'" + "_" + "'nb_syllabes_total_dans_mot'"


		fin_mot = Get end time of interval: 5, interval_mot_diphone_part2
		debut_mot_suivant = Get start time of interval: 5, interval_mot_diphone_part2+1
		interval_syllabe_debut_mot_suivant_part2 = Get interval at time: 6, debut_mot_suivant+0.0001
		nb_syllabes_restant_dans_mot_part2 = interval_syllabe_debut_mot_suivant_part2 - interval_syllabe_diphone_part2
		fin_mot_precedent = Get end time of interval: 5, interval_mot_diphone_part2-1
		interval_syllabe_fin_mot_precedent_part2 = Get interval at time: 6, fin_mot_precedent-0.0001
		nb_syllabes_total_dans_mot = interval_syllabe_debut_mot_suivant_part2 -  interval_syllabe_fin_mot_precedent_part2 - 1
		position_syllabe_dans_mot_part2 = nb_syllabes_total_dans_mot - nb_syllabes_restant_dans_mot_part2 + 1
		position_syllabe_dans_mot_part2$ = "'position_syllabe_dans_mot_part2'" + "_" + "'nb_syllabes_total_dans_mot'"


###############################################################
##################### pour syllabe part 1 #####################

x = b

repeat
	start_temp = Get start time of interval: 1, x
	start_temp = start_temp + 0.0001
	interval_syllabe_suivante = Get interval at time: 6, start_temp
	nb_phonemes_restant_dans_syllabe = x - b
	x = x + 1
until interval_syllabe_suivante = interval_syllabe_diphone_part1 + 1

x = b

repeat
	start_temp = Get start time of interval: 1, x
	start_temp = start_temp + 0.0001
	interval_syllabe_suivante = Get interval at time: 6, start_temp
	nb_phonemes_precedent_dans_syllabe = b - x
	x = x - 1
until interval_syllabe_suivante = interval_syllabe_diphone_part1 - 1


nb_phonemes_dans_syllabe = nb_phonemes_restant_dans_syllabe + nb_phonemes_precedent_dans_syllabe - 1
position_diphone_part1_dans_syllabe = nb_phonemes_dans_syllabe - nb_phonemes_restant_dans_syllabe + 1
position_diphone_part1_dans_syllabe$ = "'position_diphone_part1_dans_syllabe'" + "_" + "'nb_phonemes_dans_syllabe'"
#pause 'intervalle$' ... 'position_diphone_part1_dans_syllabe$'

###############################################################
##################### pour syllabe part 2 #####################

x = b+1

repeat
	temp1$ = Get label of interval: 1, x
	start_temp = Get start time of interval: 1, x
	start_temp = start_temp + 0.0001
	interval_syllabe_suivante = Get interval at time: 6, start_temp
	temp2$ = Get label of interval: 6, interval_syllabe_suivante
	nb_phonemes_restant_dans_syllabe = x - b - 1
	x = x + 1


until interval_syllabe_suivante = interval_syllabe_diphone_part2 + 1

x = b+1

repeat
	start_temp = Get start time of interval: 1, x
	start_temp = start_temp + 0.0001
	interval_syllabe_suivante = Get interval at time: 6, start_temp
	nb_phonemes_precedent_dans_syllabe = b - x + 1
	x = x - 1
until interval_syllabe_suivante = interval_syllabe_diphone_part2 - 1


nb_phonemes_dans_syllabe = nb_phonemes_restant_dans_syllabe + nb_phonemes_precedent_dans_syllabe - 1
position_diphone_part2_dans_syllabe = nb_phonemes_dans_syllabe - nb_phonemes_restant_dans_syllabe + 1
position_diphone_part2_dans_syllabe$ = "'position_diphone_part2_dans_syllabe'" + "_" + "'nb_phonemes_dans_syllabe'"



###############################################################

###############################################################
################### pour mot part 1 ##################################

x = b

repeat
	start_temp = Get start time of interval: 1, x
	start_temp = start_temp + 0.0001
	interval_mot_suivant = Get interval at time: 5, start_temp
	nb_phonemes_restant_dans_mot = x - b
	x = x + 1
until interval_mot_suivant = interval_mot_diphone_part1 + 1

x = b

repeat
	start_temp = Get start time of interval: 1, x
	start_temp = start_temp + 0.0001
	interval_mot_suivant = Get interval at time: 5, start_temp
	nb_phonemes_precedent_dans_mot = b - x
	x = x - 1
until interval_mot_suivant = interval_mot_diphone_part1 - 1


nb_phonemes_dans_mot = nb_phonemes_restant_dans_mot + nb_phonemes_precedent_dans_mot - 1
position_diphone_part1_dans_mot = nb_phonemes_dans_mot - nb_phonemes_restant_dans_mot + 1
position_diphone_part1_dans_mot$ = "'position_diphone_part1_dans_mot'" + "_" + "'nb_phonemes_dans_mot'"



###############################################################
################### pour mot part 2 ##################################


x = b+1

repeat
	start_temp = Get start time of interval: 1, x
	start_temp = start_temp + 0.0001
	interval_mot_suivant = Get interval at time: 5, start_temp
	nb_phonemes_restant_dans_mot = x - b - 1
	x = x + 1
until interval_mot_suivant = interval_mot_diphone_part2 + 1

x = b+1

repeat
	start_temp = Get start time of interval: 1, x
	start_temp = start_temp + 0.0001
	interval_mot_suivant = Get interval at time: 5, start_temp
	nb_phonemes_precedent_dans_mot = b - x + 1
	x = x - 1
until interval_mot_suivant = interval_mot_diphone_part2 - 1


nb_phonemes_dans_mot = nb_phonemes_restant_dans_mot + nb_phonemes_precedent_dans_mot - 1
position_diphone_part2_dans_mot = nb_phonemes_dans_mot - nb_phonemes_restant_dans_mot + 1
position_diphone_part2_dans_mot$ = "'position_diphone_part2_dans_mot'" + "_" + "'nb_phonemes_dans_mot'"







###########################################################################
###########################################################################







fileappend 'result$' 'nom_file_sans_extension$''tab$''diphone$''tab$''mot$''tab$''mot_suivant$''tab$''duree''tab$''f0_mid_part1''tab$''f0_mid_part2'
... 'tab$''meme_syllabe''tab$''position_syllabe_dans_mot_part1$''tab$''position_syllabe_dans_mot_part1$'
... 'tab$''position_diphone_part2_dans_syllabe$''tab$''position_diphone_part2_dans_syllabe$'
... 'tab$''position_diphone_part1_dans_mot$''tab$''position_diphone_part2_dans_mot$''newline$'


if (b=15 or b=30 or b=100 or b=1000)
pause 'b' 'milieu_intervalle'	'val_coarticulation_sound_final_duree:2' 'val_coarticulation_sound_final_mean:2'	'val_coarticulation_sound_final_max:2'
endif

	endfor





	select 'textgrid'
	nocheck plus 'son'
	Remove


endfor


