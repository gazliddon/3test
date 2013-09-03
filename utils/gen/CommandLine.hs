{-# LANGUAGE DeriveDataTypeable #-}
module CommandLine where

import System.Console.CmdArgs

data CommandLine = CommandLine
  { outFile :: FilePath
  , numOfObjs :: Int
  , complexity :: Int
  , objectName :: String
  , seed :: Int }
  deriving (Show, Data, Typeable)

commandLineOpts = CommandLine
  { outFile =   "" &= typFile &= help "Output file name"
  , numOfObjs = 1 &= name "n" &= typ "NUM" &= help "Number of hulls to generate"
  , complexity = 20 &= name "c" &= typ "NUM" &= help "Points per object"
  , objectName = "test" &= name "e" &= typFile &= help "Object name"
  , seed = 123
  }

commandLine = cmdArgs commandLineOpts

