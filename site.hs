--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid (mappend)
import Hakyll
import Text.Pandoc
--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
  match ("images/*" .||. "favicon.ico" .||. "robots.txt") $ do
    route   idRoute
    compile copyFileCompiler

  match "css/*" $ do
    route   idRoute
    compile compressCssCompiler

  match (fromList ["index.html", "contact.html"]) $ do
    route   $ setExtension "html"
    compile $ getResourceBody
      >>= loadAndApplyTemplate "templates/default.html" defaultContext
      >>= relativizeUrls

  match "jobs/*" $ do
    route $ setExtension "html"
    compile $ html5Compiler
      >>= loadAndApplyTemplate "templates/job.html"    jobCtx
      >>= loadAndApplyTemplate "templates/default.html" jobCtx
      >>= relativizeUrls

  match "career.html" $ do
    route  idRoute
    compile $ do
      jobs <- recentFirst =<< loadAll "jobs/*"
      let careerCtx = listField "jobs" jobCtx (return jobs) `mappend`
                      defaultContext

      getResourceBody
        >>= applyAsTemplate careerCtx
        >>= loadAndApplyTemplate "templates/default.html" careerCtx
        >>= relativizeUrls

  match "templates/*" $ compile templateCompiler

--------------------------------------------------------------------------------

jobCtx :: Context String
jobCtx = dateField "date" "%B %e, %Y" `mappend` defaultContext

html5Compiler :: Compiler (Item String)
html5Compiler = pandocCompilerWith defaultHakyllReaderOptions html5Writer

html5Writer :: WriterOptions
html5Writer = defaultHakyllWriterOptions { writerHtml5 = True }
