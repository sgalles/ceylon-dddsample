
shared Comparison ceylonComparison(Integer javaComparison) 
		=> switch (javaComparison)
			case (0)    equal
			case (1)   larger
			case (-1) smaller
			else nothing;

