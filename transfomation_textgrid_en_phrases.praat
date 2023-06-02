dossierSon$ = "dossier\"

regexp$ = dossierSon$ + "*.wav"
listeFichiers = Create Strings as file list: "fileList", "'regexp$'"
nombreFichiers = Get number of strings


for indiceFichier from 1 to nombreFichiers
	select 'listeFichiers'
	fichier$ = Get string: indiceFichier
	cheminMicro$ = dossierSon$ + fichier$
  cheminGrid$ = dossierSon$ + fichier$ - ".wav" + ".TextGrid"

  micro = Read from file: cheminMicro$
  grid = Read from file: cheminGrid$
	save_file_name$ = fichier$ - ".wav" + "_phrases.txt"

	select 'grid'
	nb_intervalles_mots = Get number of intervals: 5


	for a from 1 to nb_intervalles_mots
		start_intervalle_mot = Get start time of interval: 5, a
		intervalle_tier2 = Get interval at time: 2, start_intervalle_mot + 0.0001
		label$ = Get label of interval: 2, intervalle_tier2


		if (label$ = "<s>" or label$ = "{breath}" or label$ = "[silence]")
			appendFile: save_file_name$
		elsif label$ = "</s>"
			appendFile: save_file_name$, newline$
		elsif (label$ = "&hm" or label$ = "&ouais" or label$ = "&ben")
			label$ = right$(label$,length(label$)-1)
			appendFile: save_file_name$, label$ + " "
		else
			appendFile: save_file_name$, label$ + " "
		endif

	endfor

endfor
