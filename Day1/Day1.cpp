#include <fstream>
#include <iostream>
#include <string>
#include <vector>


void task_one()
{
	std::ifstream file( "input.txt" );
	if ( file.is_open() )
	{
		int depth_increases = 0;
		int current_depth = 0;
		std::string next_line;
		while ( std::getline( file, next_line ) )
		{
			int new_depth = std::stoi( next_line );
			// This check won't work if it is valid for the depth to be 0 but is fine for the data given.
			if ( current_depth != 0 && current_depth < new_depth )
			{
				depth_increases++;
			}

			current_depth = new_depth;
		}
		file.close();
		
		std::cout << "Depth increased " << depth_increases << " times" << std::endl;
	}
	else
	{
		std::cout << "Unable to read input file!";
	}
}

void task_two()
{
	std::ifstream file( "input.txt" );
	if ( file.is_open() )
	{
		std::vector<int> depths;
		std::string next_line;
		while ( std::getline( file, next_line ) )
		{
			depths.push_back( std::stoi( next_line ) );
		}
		file.close();

		int depth_increases = 0;
		int current_sum = 0;
		for ( uint16_t i = 2;  i < depths.size(); i++ )
		{
			int new_sum = depths[i - 2] + depths[i - 1] + depths[i];
			// This check won't work if it is valid for the sum to be 0 but is fine for the data given.
			if ( current_sum != 0 && current_sum < new_sum )
			{
				depth_increases++;
			}
			current_sum = new_sum;
		}
		std::cout << "Sum increased " << depth_increases << " times" << std::endl;
	}
	else
	{
		std::cout << "Unable to read input file!";
	}
}


int main()
{
	task_one();
	task_two();
}