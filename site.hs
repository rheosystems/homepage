{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid ((<>))
import GHC.IO.Encoding (setLocaleEncoding, utf8)
import Hakyll


main :: IO ()
main = do
  setLocaleEncoding utf8
  hakyllWith config $ do
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
        let ctx = listField "essays" defaultContext (return essays) <> defaultContext

        getResourceBody
          >>= applyAsTemplate ctx
          >>= loadAndApplyTemplate "templates/default.html" ctx
          >>= relativizeUrls

    match "templates/*" $ compile templateCompiler

    create ["sitemap.xml"] $ do
      route   idRoute
      compile $ do
        essays <- loadAll "essays/*"
        let ctx = listField "essays" defaultContext (return essays) <> defaultContext

        makeItem ""
          >>= loadAndApplyTemplate "templates/sitemap.xml" ctx

config :: Configuration
config = defaultConfiguration
  { deployCommand = "aws s3 --region eu-central-1 sync ./_site s3://rheosystems.com" }
