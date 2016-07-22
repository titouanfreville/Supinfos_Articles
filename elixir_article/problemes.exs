defmodule Problemes do
  # @name fibo
  # fonction calculant le n-ème terme de la suite de ibonacci
  # @param n int n ;)
  # @return valeur du n eme terme de la suite de fibonacci
  def fibo n do
    cond do
      n == 0 -> 0
      n == 1 -> 1
      true -> fibo(n-1) + fibo(n-2) 
    end
  end

  # @name hanoi
  # fonction affichant la combinaison d'étape à faire pour résoudre le problème.
  # @param n int nombre de disque 
  # @para d string pique de départ
  # @para a string pique intermédiaire
  # @para i string pique d'arrivée
  def hanoi n,d,a,i do
    cond do
      n == 0 -> ""
      n == 1 -> d <> a 
      true -> hanoi((n-1),d,i,a) <> "- " <> hanoi(1,d,a,i) <> " - " <> hanoi((n-1),i,a,d) 
    end
  end
end

Problemes.fibo 10
Problemes.hanoi 3, "D","A","I"
