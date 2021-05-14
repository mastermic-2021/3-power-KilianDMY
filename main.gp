str2ascii(s) = Vec(Vecsmall(s));
ascii2str(v) = Strchr(v);

encodegln(s, n) = {
  my(v);
  v =[ if(x == 32, 0, x-96) | x <- str2ascii(s) ];
  if(#v > n^2, warning("string truncated to length ", n^2));
  v = Vec(v, n^2);
  matrix(n, n, i, j, v[ (i-1)*n +j ]);
}

\\ On transforme la matrice 'chiffré' en un vecteur.
\\ Pour cela on concatene les vecteur de la matrice.

mat_concat(matrice) = {
  my(taille = matsize(matrice)[1]);
  my(res = vector(taille^2));
  for(i = 1, taille,
    for(j = 1, taille,
      res[ (i-1)*taille +j ] = matrice[i, j]
    );
  );
  res;
}

\\ On decode le vecteur

decodegln(v) = {
  ascii2str([ if( s == 0, 32, s + 96) | s <- v]);
}


\\ Énoncé :
\\ Z/27Z d'après l'énoncé. 0 = espace, 1 = a, ...
\\ n = 2^16 + 1


taille_alphabet = 27;
nb = 65537;


texte = readstr("input.txt")[1];
chiffre_mat = encodegln(texte, 12);

\\ On passe le chiffre de forme matricielle en vectorielle.
chiffre = mat_concat(chiffre_mat);



\\ On calcule la taille de la matrice en fonction du chiffré.

tailleMat = sqrt(#chiffre);
tailleMat = truncate(tailleMat);

\\ On retire la partie decimale.


\\ On crée la matrice.

matrice = matrix(tailleMat, tailleMat, i, j, chiffre[j + (i-1) * tailleMat]);




\\ On calcule l'ordre de la matrice "mat".

ordreMat(mat, taille) = {
	res = 1;
  tmp = mat;
	while(tmp != matid(taille),
		tmp = lift(Mod(tmp, taille_alphabet) * mat);
		res ++;
	);
	res;
};



ord = ordreMat(matrice, tailleMat);

\\ Ici l'ordre est ord = 531432.



\\ On calcul l'inverse de nb modulo ord, l'ordre de matrice.

p = bezout(nb, ord);


clair = Mod(matrice, taille_alphabet) ^ p[1];



\\ On crée un vecteur à l'aide du clair.

vecteur =  vector(tailleMat * tailleMat -1, k, clair[ (divrem(k - 1, tailleMat)[1]) + 1, ((k - 1) % tailleMat) + 1] );


\\ On decode et on affiche.

print(decodegln(lift(vecteur)));
