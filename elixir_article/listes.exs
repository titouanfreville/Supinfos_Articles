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

end 
