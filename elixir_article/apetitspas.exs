defmodule Maths do
  # @name puissance
  # Fonction permettant de calculer la valeur de a^b. 
  # @param a int entier dont on cherche la puissance
  # @param b int entier représenter la puissance à la quelle élever a
  # @return a^b
  def puissance(a, b) do
    cond do
      b==0 -> 1
      true -> a * puissance(a, b-1)
    end
  end
  # @name puissance
  # Fonction permettant de calculer la valeur de a!. 
  # @param a int entier dont on cherche la factorielle
  # @return a!
  def factorielle(a) do
    cond do
      a==0 -> 1
      true -> a * factorielle(a-1)
    end
  end
end 
