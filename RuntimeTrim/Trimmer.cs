//
// MIT License
//
// Copyright (c) 2023 Aptivi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

using RuntimeTrim.RidGraph;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace RuntimeTrim
{
    internal class Trimmer
    {
        static void Main(string[] args)
        {
            // Check for provided paths
            if (args.Length == 0)
            {
                Console.WriteLine("You must specify a path or a group of paths to the build output that contains the runtimes folder.");
                Environment.Exit(1);
            }

            // Now, check for every path.
            var finalPaths = new List<string>();
            foreach (string path in args)
            {
                // First, check for build output existence
                if (!Directory.Exists(path))
                {
                    Console.WriteLine("Path {0} doesn't exist! Make sure that this is the correct path and that it includes the runtimes folder.", path);
                    Environment.Exit(2);
                }

                // Now, check for the runtimes folder
                string runtimesPath = Path.Combine(path, "runtimes");
                if (!Directory.Exists(runtimesPath))
                    Console.WriteLine("Path {0} doesn't exist! This build output may be platform-neutral or may not use platform-specific assemblies. Not touching.", runtimesPath);
                else
                    finalPaths.Add(runtimesPath);
                Console.WriteLine("Path {0} processed.", runtimesPath);
            }

            // Now, use the RID graph reader to query for extra architectures. This is important so developers could build
            // debianized versions of .NET applications using Makefile + debian/ folder.
            var includeArchs = RidGraphReader.GetGraphFromRid();
            foreach (string runtime in finalPaths)
            {
                // Iterate through all found architecture folders once we have the full list so that we can have a list for
                // removing extra architecture folders.
                var runtimeAsmFolders = Directory
                    .GetFileSystemEntries(runtime, "*", SearchOption.TopDirectoryOnly)
                    .Where((path) => Directory.Exists(path))
                    .ToArray();
                var runtimeAsmFoldersBlacklist = runtimeAsmFolders
                    .Except(includeArchs.Select((arch) => Path.Combine(runtime, arch)))
                    .ToArray();

                // Now, remove every folder listed in the blacklist
                foreach (var runtimeAsm in runtimeAsmFoldersBlacklist)
                {
                    try
                    {
                        Console.WriteLine("Trimming {0}.", runtimeAsm);
                        Directory.Delete(runtimeAsm, true);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("Failed to trim {0}: {1}", runtimeAsm, ex.Message);
                    }
                }
            }

            // Write a congratulatory message
            Console.WriteLine("Trimmed to just [{0}]!", string.Join(", ", includeArchs));
        }
    }
}
