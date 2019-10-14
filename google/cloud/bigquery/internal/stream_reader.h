// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#ifndef BIGQUERY_INTERNAL_STREAMING_READER_H_
#define BIGQUERY_INTERNAL_STREAMING_READER_H_

#include "google/cloud/bigquery/version.h"
#include "google/cloud/optional.h"
#include "google/cloud/status_or.h"

namespace google {
namespace cloud {
namespace bigquery {
inline namespace BIGQUERY_CLIENT_NS {
namespace internal {

// A class for representing a server stream that will return zero or
// more messages of type T. This class exists to hide away the details
// of the underlying transport stub, e.g., gRPC.
template <class T>
class StreamReader {
 public:
  virtual ~StreamReader() = default;

  // Reads the next value from the stream.
  //
  // If a value exists, an optional containing the value is returned.
  //
  // If the end of the stream is reached, an empty optional is
  // returned.
  //
  // Any non-OK status signals that something went wrong reading from
  // the stream.
  virtual google::cloud::StatusOr<google::cloud::optional<T>> NextValue() = 0;
};

}  // namespace internal
}  // namespace BIGQUERY_CLIENT_NS
}  // namespace bigquery
}  // namespace cloud
}  // namespace google

#endif  // BIGQUERY_INTERNAL_STREAMING_READER_H_
