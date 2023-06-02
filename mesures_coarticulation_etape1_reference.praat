

path_wav$ = "dossier"
path_coarticulation$ = "dossier"

result$ = "resultat_coarticulation_nccfr_final_non_normalise.txt"
fileappend 'result$' file'tab$'diphone'tab$'mean'tab$'max'tab$'min'tab$'disp_max_min'tab$'std'tab$'duree'newline$'


string_wav = Create Strings as file list: "fileList", "D:\corpus_nimegue\wav\*.wav"
nb_wav = Get number of strings

for a from 1 to nb_wav
	printline 'a'
	select 'string_wav'
	nom_file$ = Get string: a
	nom_file_sans_extension$ = nom_file$ - ".wav"
	textgrid_file$ = path_wav$ + "\" + nom_file_sans_extension$ +  ".TextGrid"
	textgrid = Read from file: "'textgrid_file$'"
	nb_intervals = Get number of intervals: 1


	coarticulation_file$ = path_coarticulation$ + "\output_" + nom_file_sans_extension$ + ".txt"
	table = Read Table from tab-separated file: "'coarticulation_file$'"
	matrix1 = Down to Matrix
	matrix2 = Transpose
	coarticulation_sound = To Sound
	coarticulation_sound = Override sampling frequency: 200
	coarticulation_sound = Shift times by: -0.5


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

		select 'coarticulation_sound'
		max = Get maximum: milieu_intervalle, milieu_intervalle_suivant, "Sinc70"
		min = Get minimum: milieu_intervalle, milieu_intervalle_suivant, "Sinc70"
		disp_max_min = max-min
		mean = Get mean: 0, milieu_intervalle, milieu_intervalle_suivant
		std = Get standard deviation: 0, milieu_intervalle, milieu_intervalle_suivant
		duree = round((milieu_intervalle_suivant-milieu_intervalle)*1000)

fileappend 'result$' 'nom_file_sans_extension$''tab$''diphone$''tab$''mean:2''tab$''max:2''tab$''min:2''tab$''disp_max_min:2''tab$''std:2''tab$''duree''newline$'
pause 'b' 'duree' 'max'


	endfor


	select 'table'
	nocheck plus 'son'
	plus 'textgrid'
	plus 'matrix1'
	plus 'matrix2'
	plus 'coarticulation_sound'
	Remove

endfor