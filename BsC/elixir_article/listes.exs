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

  # @name divise
  # Fonction prenant une liste et renvoyant celle ci coupé en deux moitié si possible égale.
  # @param l list liste à diviser
  # @param acc1 list liste de stockage
  # @param acc2 list liste de stockage
  # @return la liste divisé en 2 sous forme de couple. 
  def divise(l, acc1 \\ [], acc2 \\ []) do
    cond do 
      l == [] -> { acc1, acc2 }
      (tl l) == [] -> { [hd l] ++ acc1 , acc2 }
      true ->
        divise(tl(tl l), ([hd l] ++ acc1), ([hd(tl l)] ++ acc2))
    end
  end
  # @name fusionne
  # Fonction fusionnant deux liste trié en une unique liste triée
  # @param l1 list première liste triée
  # @param l2 list deuxième liste triée
  # @param acc list liste de stockage
  # @param comp function fonction de comparaison
  # @return l1 fusionné à l2 et trié.
  def fusionne(l1,l2,acc \\ []) do
    cond do
      l1 == [] -> acc ++ l2
      l2 == [] -> acc ++ l1
      true -> 
        (hd l1) < (hd l2) &&
        fusionne((tl l1), l2, (acc ++ [hd l1])) ||
        fusionne(l1, (tl l2), (acc ++ [hd l2]))
    end
  end
  # @name tri_fusion
  # Trie la liste passé en argument
  # @param l list liste à triée
  # @param acc list list de stockage
  # @param comp function fonction de comparaison à utiliser
  # @return liste l triée
  def tri_fusion(l,acc \\ []) do
    cond do
      l == [] -> acc
      (tl l)==[] -> l
      true -> 
        tuple = divise l
        l1 = elem(tuple, 0)
        l2 = elem(tuple, 1)
        fusionne (tri_fusion l1), (tri_fusion l2), []
    end
  end
  # @name croissant
  # Opérateur de comparaison pour trier les entier par ordres croissant
  # @param a int entier a
  # @param b int entier b
  # @return true si a < b, false sinon
  def croissant(a,b) do
    a < b
  end

  def ex_trifusion_cint(l) do
    tri_fusion(l)
  end
end 
