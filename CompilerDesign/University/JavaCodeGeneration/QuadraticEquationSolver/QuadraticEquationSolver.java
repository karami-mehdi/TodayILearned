public class QuadraticEquationSolver {

    public static void main(String[] args) {
        double a = 1.0;
        double b = -3.0;
        double c = 2.0;
        
        double[] roots = solveQuadraticEquation(a, b, c);
        
        if (roots != null) {
            System.out.println("Root 1: " + roots[0]);
            System.out.println("Root 2: " + roots[1]);
        } else {
            System.out.println("The equation has no real roots.");
        }
    }
    
    /**
     * Solves the quadratic equation ax^2 + bx + c = 0.
     * 
     * @param a Coefficient of x^2
     * @param b Coefficient of x
     * @param c Constant term
     * @return An array containing the two roots, or null if there are no real roots.
     */
    public static double[] solveQuadraticEquation(double a, double b, double c) {
        // Calculate the discriminant (b^2 - 4ac)
        double discriminant = b * b - 4 * a * c;
        
        // Check if the discriminant is non-negative (real roots exist)
        if (discriminant < 0) {
            return null; // No real roots
        }
        
        // Calculate the two roots using the quadratic formula
        double sqrtDiscriminant = Math.sqrt(discriminant);
        double root1 = (-b + sqrtDiscriminant) / (2 * a);
        double root2 = (-b - sqrtDiscriminant) / (2 * a);
        
        return new double[] { root1, root2 };
    }
}
