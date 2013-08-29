{-# LANGUAGE DeriveDataTypeable #-}
module CommandLine where

import System.Console.CmdArgs

data CommandLine = CommandLine
  { outFile :: String
  , numOfObjs :: Integer
  , complexity :: Integer
  , objectName :: String
  , seed :: Integer
}

commandLineOpts = CommandLine
  { outFile =   def &= name "o" &= typFile &= help "Output file"
  , numOfObjs = def &= name "n" &= typ "NUM" &= help "Number of hulls to generate"
  , complexity = def &= name "c" &= typ "NUM" &= help "Points per object"
  , objectName = def &= name "e" &= typFile &= help "Object name"
  , seed = 123
  }

data Sample = Sample {hello :: String}
              deriving (Show, Data, Typeable)

sample = Sample{hello = def}

commandLine = print =<< cmdArgs sample
