// Copyright 2017 Verilab Inc.
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

`ifndef __gpio_param_pkg__
`define __gpio_param_pkg__

package gpio_param_pkg;

  // Global parameters.
  parameter GPIO // Set to project-wide max gpio width.
            = proj_param_pkg::PROJ_GPIO;

  // Local parameters.
  typedef bit [GPIO-1:0] GPIO_t;
endpackage

`endif

