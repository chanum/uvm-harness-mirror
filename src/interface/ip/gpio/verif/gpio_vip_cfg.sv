//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

`ifndef __gpio_vip_cfg__
`define __gpio_vip_cfg__

class gpio_vip_cfg extends uvm_object;

  agent_role role;

  `uvm_object_utils_begin(gpio_vip_cfg)
    `uvm_field_enum(agent_role, role, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "gpio_vip_cfg");
    super.new(name);
  endfunction
endclass

`endif

