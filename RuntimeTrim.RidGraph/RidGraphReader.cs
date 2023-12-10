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

using RuntimeTrim.RidGraph.Properties;
using System;
using System.Runtime.InteropServices;
using System.Text.Json;
using System.Text.Json.Nodes;

namespace RuntimeTrim.RidGraph
{
    /// <summary>
    /// Tools for reading the RID graph
    /// </summary>
    public static class RidGraphReader
    {
        /// <summary>
        /// Gets the graph from the current RID
        /// </summary>
        /// <returns>List of RIDs from the current RID to the base RID</returns>
        public static string[] GetGraphFromRid() =>
            GetGraphFromRid(RuntimeInformation.RuntimeIdentifier);

        /// <summary>
        /// Gets the graph from the specified RID
        /// </summary>
        /// <returns>List of RIDs from the specified RID to the base RID</returns>
        public static string[] GetGraphFromRid(string rid)
        {
            string graphJson = Resources.RidGraph;
            var graphInstance = JsonNode.Parse(graphJson);
            foreach (var ridGraph in graphInstance.AsObject())
            {
                if (ridGraph.Key == rid)
                {
                    var graph = ridGraph.Value;
                    var graphArray = graph.Deserialize<string[]>();
                    return graphArray;
                }
            }
            return Array.Empty<string>();
        }
    }
}
