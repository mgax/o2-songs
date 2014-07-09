Cântece de la Oxigen
====================

Un site cu cântece de munte de la Asociația Oxigen: [o2.grep.ro](http://o2.grep.ro/)


Cum adaug un cântec?
--------------------
Fiecare cântec este un fișier în directorul [songs](https://github.com/mgax/o2-songs/tree/gh-pages/songs) din repository. Fișierul are următorul format:

* O zonă inițială de metadate. Aici este titlul cântecului. Linia cu `layout` trebuie să rămână neschimbată.
* Strofele sunt separate de câte un rând liber. În HTML vor deveni paragrafe (`<p>`).
* Versurile au două spații albe la sfârșit. În HTML vor fi separate de newline (`<br>`).
* Numele fișierului trebuie să urmeze titlul cântecului. Pentru exemplul de mai jos, numele de fișier ar fi `cantec-de-exemplu.md`.

```
---
title: Cântec de exemplu
layout: song
---

la la la  
la la la  
```

Pentru a adăuga un cântec, apăsați pe butonul "+" din [directorul de cântece](https://github.com/mgax/o2-songs/tree/gh-pages/songs).
