dossier$ = "dossier\"
regexp$ = dossier$ + "*.conllu"

liste = Create Strings as file list: "fileList", "'regexp$'"
nombreFichiers = Get number of strings

for variableFor from 1 to nombreFichiers
select 'liste'
fichier$ = Get string: variableFor
cheminGrid$ = dossier$ + fichier$
fichier_kim = Read Strings from raw text file: cheminGrid$
nb_lines = Get number of strings

debut = 0
fin = 0

for z from 1 to nb_lines
  string1$ = Get string: z
  if left$(string1$,9) = "# sent_id"
    debut = debut + 1
    debut_phrase'debut' = z
  endif
  if left$(string1$,1) = ""
    fin = fin + 1
    fin_phrase'fin' = z
  endif
endfor

dossier2$ = "dossier\"
fichier2$ = fichier$ - "_conllu.conllu" + ".TextGrid"
grille = Read from file: dossier2$ + fichier2$
nb_intervalles_niveau_5 = Get number of intervals: 5
nb_intervalles_niveau_2 = Get number of intervals: 2
Duplicate tier: 5, 7, ""
Replace interval texts: 7, 1, 0, "[a-zA-Z@.&]", " ", "Regular Expressions"

nouvelle_phrase = 0

for a from 1 to nb_intervalles_niveau_2
  select 'grille'
  label_niveau_2$ = Get label of interval: 2, a

  if label_niveau_2$ = "<s>"
    nouvelle_phrase = nouvelle_phrase + 1

    while (label_niveau_2$ = "<s>" or label_niveau_2$ = "'{breath}'" or label_niveau_2$ = "'[silence]'")
      a = a + 1
      label_niveau_2$ = Get label of interval: 2, a
    endwhile

    temps_debut = Get start time of interval: 2, a
    intervalle_mot_phonetique = Get interval at time: 5, temps_debut+0.001
    label_niveau_5$ = Get label of interval: 5, intervalle_mot_phonetique
	
    valeur_debut = debut_phrase'nouvelle_phrase'+4
    valeur_fin = fin_phrase'nouvelle_phrase'

    for c from valeur_debut to valeur_fin-1
      select 'fichier_kim'
      ligne_a_analyser$ = Get string: c

      premiere_tab = index(ligne_a_analyser$,"	")
      ligne_a_analyser_moins_debut$ = right$(ligne_a_analyser$,length(ligne_a_analyser$)-premiere_tab)
      deuxieme_tab = index(ligne_a_analyser_moins_debut$,"	")
      mot$ = left$(ligne_a_analyser_moins_debut$,deuxieme_tab-1)
      reste$ = left$(ligne_a_analyser$,length(ligne_a_analyser$)-4)
      info = rindex(reste$,"	")
      reste$ = right$(reste$,length(reste$)-info)
	
      select 'grille'
      label_niveau_5$ = Get label of interval: 5, intervalle_mot_phonetique
      nouveau_temps_debut = Get start time of interval: 7, intervalle_mot_phonetique
      a = Get interval at time: 2, nouveau_temps_debut+0.001
      label_niveau_2$ = Get label of interval: 2, a

      while (label_niveau_2$ = "[silence]" or label_niveau_2$ = "{breath}" or label_niveau_2$ = "<s>" or label_niveau_2$ = "</s>")
	    intervalle_mot_phonetique = intervalle_mot_phonetique + 1
        nouveau_temps_debut = Get start time of interval: 7, intervalle_mot_phonetique
        a = Get interval at time: 2, nouveau_temps_debut+0.001
        label_niveau_2$ = Get label of interval: 2, a
	  endwhile
	  
	  Set interval text: 7, intervalle_mot_phonetique, "'reste$'"
	  intervalle_mot_phonetique = intervalle_mot_phonetique + 1

    endfor
  endif	
endfor
select 'grille'
dossier3$ = "dossier"
Save as text file: dossier3$ + fichier2$ - ".TextGrid" + "_dependances.TextGrid"
endfor