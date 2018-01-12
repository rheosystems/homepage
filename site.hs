{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid (mappend)
import Hakyll


main :: IO ()
main = hakyll $ do
  match ("images/*" .||. "favicon.ico" .||. "robots.txt") $ do
    route idRoute
    compile copyFileCompiler

  match "css/*" $ do
    route idRoute
    compile compressCssCompiler

  match (fromList ["index.html", "contact.html"]) $ do
    route $ setExtension "html"
    compile $ getResourceBody
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

  match "essays/*" $ do
    route $ setExtension "html"
    compile $ pandocCompiler
      >>= loadAndApplyTemplate "templates/essay.html" defaultContext
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls


  match "essays.html" $ do
    route idRoute
    compile $ do
      essays <- loadAll "essays/*"
      let ctx = listField "essays" defaultContext (return essays) `mappend` defaultContext

      getResourceBody
        >>= applyAsTemplate ctx
        >>= loadAndApplyTemplate "templates/default.html" ctx
        >>= relativizeUrls

  match "templates/*" $ compile templateCompiler
