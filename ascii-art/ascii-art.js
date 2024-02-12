/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
list = []
const L = parseInt(readline());
const H = parseInt(readline());
const T = readline();
for (let i = 0; i < H; i++) {
    const ROW = readline();
    list.push(ROW)
}
//console.log(T)
var alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
// Write an answer using console.log()
texteNum = []
texte = T.split('')
//console.log(texte)
for (j=0; j<texte.length; j++){
    t = texte[j]
    lettre = 26
    for (i=0;i<26;i++){
        a = alphabet[i].toString()
        if (t == a || t.toUpperCase() == a){
            lettre = i
        }
    }
    texteNum.push(lettre)

}
//console.log(texteNum)

lettre2d = []
for (i=0;i<H;i++){
    list1 = list[i].split('')
    ascii2 = ''
    for (k=0;k<texteNum.length;k++){
        l = texteNum[k] * L
        ascii = ''
        for (m=0;m<L;m++){
            ascii = ascii + list1[l+m]
        }
        ascii2 = ascii2 + ascii
        //console.log(ascii2)
    }
    lettre2d.push(ascii2)
}

for (i=0;i<H;i++){
    affichage = lettre2d[i]
    console.log(affichage)
}


// To debug: console.error('Debug messages...');





