# 3-Element Linear Antenna Array Simulation & Radiation Analysis

Analytical modeling and numerical simulation in MATLAB of a 3-element half-wavelength ($\lambda/2$) linear dipole array operating at 140 MHz. This project investigates current distributions, input impedance sensitivity across conductor radii, phased beam steering, directivity enhancement, ground plane boundary reflections via Image Theory, and link budget calculations using the Friis transmission equation.

---

## 📌 Project Overview & Specifications

* **Operating Resonant Frequency ($f_0$):** $140 \text{ MHz}$ ($\lambda \approx 2.14 \text{ m}$)
* **Dipole Geometry:** Resonant half-wavelength center-fed dipoles ($L = \lambda/2 = 1.07 \text{ m}$) positioned parallel to the x-axis, oriented along the z-axis
* **Inter-Element Spacing ($d$):** $0.65\lambda \approx 1.39 \text{ m}$
* **Array Feed Configuration:**
  * Element 1 ($z_1 = -d$): $I_{01} = 7 \text{ A}, \quad \beta_{01} = 45^\circ$ ($0.7854 \text{ rad}$)
  * Element 2 ($z_2 = 0$): $\quad I_{02} = 8 \text{ A}, \quad \beta_{02} = 52^\circ$ ($0.9076 \text{ rad}$)
  * Element 3 ($z_3 = +d$): $I_{03} = 9 \text{ A}, \quad \beta_{03} = 97^\circ$ ($1.6929 \text{ rad}$)

---

## 🔬 Core Analytical Formulations

### 1. Element Far-Field Pattern ($\lambda/2$ Dipole)
The normalized elevation radiation pattern function $F(\theta)$ for a thin half-wave dipole is given by:
$$F(\theta) = \frac{\cos\left(\frac{\pi}{2} \cos\theta\right)}{\sin\theta}$$

### 2. Analytical Array Factor ($AF$)
For an $N$-element linear array along the z-axis with electrical distance $k d = 2\pi(0.65) = 4.084 \text{ rad}$:
$$AF(\theta) = \sum_{n=1}^{N} I_n e^{j(k z_n \cos\theta + \beta_n)}$$
$$AF(\theta) = 7 e^{j(0.7854 - 4.084\cos\theta)} + 8 e^{j(0.9076)} + 9 e^{j(4.084\cos\theta + 1.6929)}$$

### 3. Total Radiated Field
Applying the pattern multiplication theorem:
$$E_{\text{total}}(\theta) = F_{\text{dipole}}(\theta) \times AF(\theta)$$

### 4. Directivity and Realized Gain
Directivity is calculated via 3D spherical integration of the radiation intensity $U(\theta, \phi)$:
$$P_{\text{rad}} = \int_0^{2\pi} \int_0^\pi U(\theta, \phi) \sin\theta \, d\theta \, d\phi$$
$$D_{\max} = \frac{4\pi U_{\max}}{P_{\text{rad}}}, \qquad G_{\max} = \eta \cdot D_{\max} \quad (\eta = 0.95)$$

### 5. Perfect Ground Plane (Image Theory)
For horizontal dipoles placed at height $h = \lambda/4$ above a Perfect Electric Conductor (PEC), the reflection coefficient is $\Gamma = -1$ (180° phase inversion):
$$E_{\text{ground}}(\theta) = 2 E_0 \left\vert{}\sin(k h \cos\theta)\right\vert{} \quad \text{for } \theta \le \frac{\pi}{2}$$

### 6. Friis Transmission Equation
Under line-of-sight free-space conditions for $P_t = 1 \text{ W}$, distance $R = 20 \text{ m}$, and matched half-wave dipoles ($D_t = D_r = 1.64$):
$$P_r = P_t \cdot G_t \cdot G_r \left(\frac{\lambda}{4\pi R}\right)^2 \cdot \text{PLF}^2$$

---

## 📊 Key Simulation Results & Findings

* **Current & Voltage Distribution:** Demonstrated that a resonant $\lambda/2$ dipole forms a current antinode (maximum) at the feed point with pure resistive impedance ($\approx 73\ \Omega$), whereas a full-wave dipole ($\lambda$) creates a current null at the center, resulting in an impractical feed impedance.
* **Impedance vs. Conductor Radius:** Conductor thickness dictates antenna bandwidth. Thinner dipoles ($a = \lambda/1000$) display steep reactance slopes and narrow operating bandwidth, while thick dipoles ($a = \lambda/100$) exhibit flatter reactance curves, significantly enhancing operational bandwidth.
* **Beamforming & Beam Steering:** Progressive phase shifts ($\beta = 45^\circ, 52^\circ, 97^\circ$) steer the main radiation lobe and introduce controlled asymmetry in the sidelobes.
* **Directivity & HPBW Narrowing:** The 3-dipole array narrows the Half-Power Beamwidth from $78.0^\circ$ (single dipole) down to $26.3^\circ$, concentrating radiated energy and elevating peak directivity to **$6.08\text{ dBi}$** ($5.86\text{ dBi}$ gain at $\eta = 95\%$).
* **Ground Reflection:** The PEC ground plane doubles the elevation directivity (+3 dB) by eliminating downward radiation and reflecting energy constructively into the upper hemisphere.
* **Received Power:** At $20 \text{ m}$ separation distance with $1 \text{ W}$ transmit power, the calculated received power is **$195.7\ \mu\text{W}$ ($-37.1\text{ dBm}$)**.

---

## 💻 Repository Structure & Usage
Running the Simulation
Clone the repository:

Bash
git clone [https://github.com/roxana-mparaschiv/antenna-array-simulation.git](https://github.com/roxana-mparaschiv/antenna-array-simulation.git)
Open MATLAB (R2021a or newer recommended).

Run antenna_array_simulation.m to generate all 2D polar plots, Cartesian dB charts, impedance sweeps, and the 3D radiation pattern surface.

🎓 Academic Context
Institution: Faculty of Electronics, Telecommunications and Information Technology (ETTI), National University of Science and Technology POLITEHNICA Bucharest

Course: Antennas and Wave Propagation

Author: Maria-Roxana Paraschiv

Academic Coordinator: Prof. Dr. Ing. Alina Bădescu
```text
├── antenna_array_simulation.m   # Complete MATLAB script covering all 7 simulation modules
└── README.md                    # Technical documentation and mathematical derivations
