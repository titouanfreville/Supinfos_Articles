defmodule Listes do
  # @name affiche
  # Fonction permettant d'afficher chaque élément de la liste sous la forme E \n E \n E .... Vide
  # @param l liste liste d'élément à afficher
  def affiche(l) do
    cond do
      l==[] -> IO.puts "Vide"
      true -> 
        IO.puts (hd l)
        affiche (tl l)
    end
  end

  # @name est_dans
  # Fonction testant la présence d'un élément dans une liste
  # @param e any élément à rechercher
  # @param l list liste dans la quelle cherché l'élément
  # @return true si l'élément existe, false sinon
  def est_dans(e,l) do
    cond do
      l==[] -> false
      true -> (hd l) == e || est_dans e,(tl l)
    end
  end
  # @name doublons_sk
  # Fonction permettant de supprimer les doublons dans une liste.
  # @param l liste liste dont on veux supprimer les doublons.
  # @return liste sans doublons.
  def doublons_sk(l) do
    cond do
      l==[] -> []
      true -> if est_dans (hd l),(tl l) do doublons_sk (tl l) else [hd l] ++ doublons_sk (tl l) end
    end
  end
  # @name nb_de
  # Fonction pour trouver le nombre d'occurrence de E dans L
  # @param e any éléments à compter
  # @param l list liste dans la quelle compter
  # @return nombre d'occurrence de E dans L
  def nb_de(e,l) do
    cond do
      l==[] -> 0
      true -> (hd l) == e && 1 + nb_de(e,(tl l)) || nb_de(e,(tl l))
    end
  end

  # @name tribulle_nonterminale
  # Fonction pour trier une liste d'entier dans l'ordre croissant. Une extension de cette fonction pourra être réaliser pour la rendre
  # plus souple ;)
  # @param l int list liste d'entier à trier
  # @return liste l trier.
  def tribulle_nonterminale(l) do
    cond do
      l==[] -> []
      (tl l) == [] -> [hd l]
      true -> 
        ltriee=tribulle_nonterminale(tl l)
        ((hd l) < (hd ltriee)) && ([hd l] ++ ltriee) || ([hd ltriee] ++ (tribulle_nonterminale([hd l]++(tl ltriee))))
    end
  end

    # @name tribulle_terminale
  # Fonction pour trier une liste d'entier dans l'ordre croissant. Une extension de cette fonction pourra être réaliser pour la rendre
  # plus souple ;)
  # @param l int list liste d'entier à trier
  # @return liste l trier.
  def tribulle_terminale(l, acc) do
    cond do
      l==[] -> acc
      (tl l) == [] -> [hd l] ++ acc
      true -> 
        ((hd l) < (hd acc)) && ([hd l] ++ acc) || ([hd acc] ++ (tribulle_terminale([hd l]++(tl acc))))
    end
  end
end 
