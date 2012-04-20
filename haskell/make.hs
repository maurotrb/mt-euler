import Development.Shake
import Development.Shake.FilePath

main = shake shakeOptions $ do
         want ["hs-euler.pdf"]
         "*.pdf" *> \out -> do
           let tex = replaceExtension out "tex"
           need [tex]
           system' "xelatex" [tex]
           system' "xelatex" [tex]
         "*.tex" *> \out -> do
           let lhs = replaceExtension out "lhs"
           incl_lhs <- getDirectoryFiles "." $ dropExtension out ++ "-*.lhs"
           need $ lhs : incl_lhs
           system' "lhs2TeX" $ ["-o",out,lhs]

